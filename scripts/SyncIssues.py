"""Mirror Khelify ticket issues from GitHub into local tasks/ files for the Ojas dispatcher.

GitHub Issues stay the source of truth. tasks/ is a generated, gitignored mirror.
Only issues with a `Ticket id:` line are tickets; the parent spec issue is skipped.
Run from the repo root:  python scripts/SyncIssues.py [--repo owner/name] [--refresh]
Idempotent: existing ticket files are never overwritten (unless --refresh and still pending);
a closed issue moves its file to done/.
"""

import argparse
import json
import re
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TASKS = ROOT / "tasks"
STATES = ("pending", "in-progress", "done", "failed")
AGENTS = {"agent:claude": "Claude Code", "agent:agy": "Antigravity (agy)"}
ROUTING_KEYS = ("Size", "Model", "Depends")


def gh_issues(repo):
    cmd = ["gh", "issue", "list", "--state", "all", "--limit", "300",
           "--json", "number,title,body,state,labels,createdAt"]
    if repo:
        cmd += ["--repo", repo]
    out = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", check=True, cwd=ROOT)
    return json.loads(out.stdout)


def section(body, name):
    m = re.search(rf"^## {name}\s*\n(.*?)(?=^## |\Z)", body, re.S | re.M)
    return m.group(1).strip() if m else ""


def routing_line(body, key):
    m = re.search(rf"^\**{key}:\**\s*`?([^`\n]+?)`?\s*$", body, re.M)
    return m.group(1).strip() if m else ""


def find_existing(slug):
    for state in STATES:
        d = TASKS / state
        if d.is_dir():
            for f in d.glob(f"{slug}-*.md"):
                return state, f
    return None


def render(issue, agent):
    body = issue["body"] or ""
    parts = [f"# [Khelify] {issue['title']}", ""]
    for key in ROUTING_KEYS:
        value = routing_line(body, key)
        if value and value.lower() != "none":
            parts.append(f"{key}: {value}")
    parts += ["", "## Issue", f"#{issue['number']}", ""]
    for name in ("What", "Why", "Acceptance Criteria", "Notes"):
        text = section(body, name)
        if text:
            parts += [f"## {name}", text, ""]
    parts += ["## Agent", agent, "", "## Created", issue["createdAt"][:10], ""]
    return "\n".join(parts)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo")
    ap.add_argument("--refresh", action="store_true", help="rewrite files still in pending/")
    args = ap.parse_args()
    for state in STATES:
        (TASKS / state).mkdir(parents=True, exist_ok=True)
    made = moved = 0
    for issue in sorted(gh_issues(args.repo), key=lambda i: i["number"]):
        slug = routing_line(issue["body"] or "", "Ticket id")
        if not slug:
            continue
        labels = {lab["name"] for lab in issue["labels"]}
        existing = find_existing(slug)
        if issue["state"] == "CLOSED":
            if existing and existing[0] in ("pending", "in-progress"):
                shutil.move(existing[1], TASKS / "done" / existing[1].name)
                moved += 1
            continue
        if "ready-for-agent" not in labels:
            continue
        if existing and not (args.refresh and existing[0] == "pending"):
            continue
        agent = next((AGENTS[lab] for lab in labels if lab in AGENTS), "Claude Code")
        path = TASKS / "pending" / f"{slug}-{issue['createdAt'][:10]}.md"
        path.write_text(render(issue, agent), encoding="utf-8")
        made += 1
    print(f"created {made}, moved to done {moved}")


if __name__ == "__main__":
    main()
