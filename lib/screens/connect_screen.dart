import 'dart:ui';
import '../themes/khelify_theme.dart';
import 'package:flutter/material.dart';
import '../models/club.dart';
import '../widgets/create_club_sheet.dart';
import '../models/planned_game.dart';
import '../widgets/plan_game_sheet.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;

  final List<Map<String, String>> _people = [
    {
      'name': 'Alex Chen',
      'role': 'Basketball Forward',
      'subtitle': 'Basketball • Wing',
    },
    {
      'name': 'Coach Lee',
      'role': 'Soccer Strategist',
      'subtitle': 'Football • Coach',
    },
    {
      'name': 'Taylor Diaz',
      'role': 'Track & Field',
      'subtitle': 'Sprinter • 200m',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KhelifyColors.cardDark,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildTabSwitcher(),
            const SizedBox(height: 12),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _tabIndex == 0
                    ? _ConnectTab(
                        people: _people,
                        key: const ValueKey('connect'),
                      )
                    : const _GuildTab(
                        key: ValueKey('guild'),
                      ),
              ),
            ),
            const SizedBox(height: 80), // space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(0.10)),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _buildTabPill(title: 'Connect', index: 0),
            _buildTabPill(title: 'Guild', index: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPill({required String title, required int index}) {
    final bool isActive = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_tabIndex != index) {
            setState(() => _tabIndex = index);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFF9800)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: KhelifyTypography.bodyMedium.copyWith(
                color: isActive ? Colors.black : Colors.white70,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CONNECT TAB
// ---------------------------------------------------------------------------

class _ConnectTab extends StatelessWidget {
  final List<Map<String, String>> people;

  const _ConnectTab({super.key, required this.people});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
          child: Text(
            'Connect',
            style: KhelifyTypography.heading1.copyWith(color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            'Grow your sports network – athletes, coaches & clubs.',
            style: KhelifyTypography.bodySmall.copyWith(
              color: Colors.white70,
            ),
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: KhelifyColors.championGold,
            decoration: InputDecoration(
              hintText: 'Find athletes, coaches, teams…',
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              filled: true,
              fillColor: const Color(0xFF1D2128),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'People You May Know',
            style: KhelifyTypography.heading3.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal cards list
        SizedBox(
          height: 240,
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 20, right: 12),
            scrollDirection: Axis.horizontal,
            itemCount: people.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final p = people[index];
              return _PersonCard(
                name: p['name']!,
                role: p['role']!,
                subtitle: p['subtitle']!,
                highlighted: index == 1,
              );
            },
          ),
        ),

        const Spacer(),

        // Explore Connections button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                // TODO: navigate to full explore page / filters
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Explore Connections',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PersonCard extends StatelessWidget {
  final String name;
  final String role;
  final String subtitle;
  final bool highlighted;

  const _PersonCard({
    required this.name,
    required this.role,
    required this.subtitle,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = highlighted ? Colors.blueAccent : Colors.transparent;

    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F27),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
      ),
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade800,
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/placeholder_athlete.png'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          Text(
            role,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // TODO: handle connect
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.amber),
                foregroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text(
                '+ Connect',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// GUILD TAB
// ---------------------------------------------------------------------------

class _GuildTab extends StatelessWidget {
  const _GuildTab({super.key});

  void _showCreateClubSheet(BuildContext context) async {
    final club = await showModalBottomSheet<Club>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CreateClubSheet(),
    );

    if (club != null) {
      debugPrint('New club created: ${club.name} in ${club.city}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Club "${club.name}" created in ${club.city}'),
          backgroundColor: KhelifyColors.sapphireBlue,
        ),
      );
    }
  }

  void _showPlanGameSheet(BuildContext context) async {
    final game = await showModalBottomSheet<PlannedGame>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const PlanGameSheet(),
    );

    if (game != null) {
      debugPrint(
        'Planned game: ${game.sport} at ${game.location} on ${game.date} ${game.time} (max ${game.maxPlayers})',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Game planned at ${game.location}'),
          backgroundColor: KhelifyColors.championGold,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GuildHeroCard(),
          const SizedBox(height: 22),
          Text(
            'Guild Actions',
            style: KhelifyTypography.heading3.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _GuildActionCard(
                  title: 'Join a Club',
                  subtitle: 'Slip into a ready squad',
                  icon: Icons.groups_3_rounded,
                  colors: const [Color(0xFF43A047), Color(0xFF2E7D32)],
                  onTap: () => _showJoinClubSheet(context),
                ),
                const SizedBox(width: 16),
                _GuildActionCard(
                  title: 'Create a Club',
                  subtitle: 'You call the plays now',
                  icon: Icons.add_circle_rounded,
                  colors: const [Color(0xFF42A5F5), Color(0xFF1565C0)],
                  onTap: () => _showCreateClubSheet(context),
                ),
                const SizedBox(width: 16),
                _GuildActionCard(
                  title: 'Plan a Game',
                  subtitle: 'Drop a time, fill the lobby',
                  icon: Icons.calendar_month_rounded,
                  colors: const [Color(0xFFFFB300), Color(0xFFF57C00)],
                  onTap: () => _showPlanGameSheet(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text(
            'Browse Clubs',
            style: KhelifyTypography.heading3.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _BrowsePill(label: 'Football squads'),
              _BrowsePill(label: 'Cricket nets'),
              _BrowsePill(label: 'Weekend hoops'),
              _BrowsePill(label: 'After‑work runs'),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuildHeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF202332), Color(0xFF12141C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.14),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join & Run!',
                      style: KhelifyTypography.heading1.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Push limits, earn stories, and play with your squad.',
                      style: KhelifyTypography.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: navigate to guild explore / rewards
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          backgroundColor: KhelifyColors.championGold,
                          foregroundColor: Colors.black,
                          elevation: 0,
                        ),
                        child: const Text(
                          'View Exciting Clubs',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 10,
                          backgroundImage: AssetImage(
                              'assets/images/placeholder_athlete.png'),
                        ),
                        const SizedBox(width: 4),
                        const CircleAvatar(
                          radius: 10,
                          backgroundImage: AssetImage(
                              'assets/images/placeholder_athlete.png'),
                        ),
                        const SizedBox(width: 4),
                        const CircleAvatar(
                          radius: 10,
                          backgroundImage: AssetImage(
                              'assets/images/placeholder_athlete.png'),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '125 already in – are you?',
                          style: KhelifyTypography.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuildActionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback? onTap;

  const _GuildActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    this.onTap,
    super.key,
  });

  @override
  State<_GuildActionCard> createState() => _GuildActionCardState();
}

class _GuildActionCardState extends State<_GuildActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _tapController.forward();
  void _onTapCancel() => _tapController.reverse();
  void _onTapUp(TapUpDetails _) => _tapController.reverse();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _tapController,
      builder: (context, child) {
        final scale = 1 - _tapController.value;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: SizedBox(
        width: 200,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: widget.colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.colors.last.withOpacity(0.40),
                  blurRadius: 22,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  widget.title,
                  style: KhelifyTypography.heading3.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: KhelifyTypography.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrowsePill extends StatelessWidget {
  final String label;

  const _BrowsePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () {
        // TODO: open filtered club list
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_outward_rounded,
                size: 14, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              label,
              style: KhelifyTypography.bodySmall.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// NOTE: _JoinClubSheet class now comes BEFORE _showJoinClubSheet

class _JoinClubSheet extends StatelessWidget {
  const _JoinClubSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Container(
      height: media.size.height * 0.8,
      decoration: BoxDecoration(
        color: KhelifyColors.cardDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // drag handle
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: KhelifyColors.textTertiary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Text(
              'Join a Club',
              style: KhelifyTypography.heading1.copyWith(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Slip into a ready squad that matches your sport and level.',
              style: KhelifyTypography.bodySmall
                  .copyWith(color: KhelifyColors.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
          // simple filters row (static for now)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _FilterChip(label: 'Football'),
                _FilterChip(label: 'Beginner'),
                _FilterChip(label: 'Nearby'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              children: const [
                _ClubListItem(
                  name: 'Elite Strikers FC',
                  subtitle: 'Football • Intermediate • Tue, Thu · 7–9 PM',
                  location: 'Indiranagar Turf',
                ),
                _ClubListItem(
                  name: 'Morning Runners Bangalore',
                  subtitle: 'Running • Mixed • Daily · 6–7 AM',
                  location: 'Cubbon Park',
                ),
                _ClubListItem(
                  name: 'Weekend Hoops Squad',
                  subtitle: 'Basketball • Casual • Sat, Sun · 5–7 PM',
                  location: 'Koramangala Courts',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showJoinClubSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _JoinClubSheet(),
  );
}

class _FilterChip extends StatelessWidget {
  final String label;
  const _FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: KhelifyColors.cardLight.withOpacity(0.04),
        border: Border.all(color: KhelifyColors.border),
      ),
      child: Text(
        label,
        style: KhelifyTypography.bodySmall
            .copyWith(color: KhelifyColors.textSecondary),
      ),
    );
  }
}

class _ClubListItem extends StatelessWidget {
  final String name;
  final String subtitle;
  final String location;

  const _ClubListItem({
    required this.name,
    required this.subtitle,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: KhelifyColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KhelifyColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: KhelifyColors.sapphireBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.groups_3_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style:
                      KhelifyTypography.heading3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: KhelifyTypography.bodySmall
                      .copyWith(color: KhelifyColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: KhelifyTypography.caption
                      .copyWith(color: KhelifyColors.textTertiary),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Request sent to join $name'),
                  backgroundColor: KhelifyColors.sapphireBlue,
                ),
              );
            },
            child: Text(
              'Join',
              style: KhelifyTypography.button.copyWith(
                color: KhelifyColors.championGold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
