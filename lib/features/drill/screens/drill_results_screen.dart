import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/constants/tier_constants.dart';
import '../../../core/widgets/glass_card.dart';
import '../models/drill.dart';
import '../services/scoring_service.dart';

class DrillResultsScreen extends ConsumerStatefulWidget {
  final Drill drill;
  final ScoringResult scoringResult;
  final int durationSeconds;

  const DrillResultsScreen({
    super.key,
    required this.drill,
    required this.scoringResult,
    required this.durationSeconds,
  });

  @override
  ConsumerState<DrillResultsScreen> createState() => _DrillResultsScreenState();
}

class _DrillResultsScreenState extends ConsumerState<DrillResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreAnimController;
  late Animation<double> _scoreAnimation;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    // Score ring animation
    _scoreAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.scoringResult.overallScore / 100.0,
    ).animate(CurvedAnimation(
      parent: _scoreAnimController,
      curve: Curves.easeOutCubic,
    ));

    // Fade-in for breakdown cards
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Start animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _scoreAnimController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scoreAnimController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tier = TierConstants.getTierFromScore(widget.scoringResult.overallScore);

    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: AppGradients.background)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Header
                  Text("Drill Complete!", style: AppTypography.h2.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(widget.drill.name, style: AppTypography.h1),
                  const SizedBox(height: 32),

                  // Score Ring
                  _buildScoreRing(tier),
                  const SizedBox(height: 32),

                  // Tier Badge
                  _buildTierBadge(tier),
                  const SizedBox(height: 32),

                  // Technique Breakdown
                  FadeTransition(
                    opacity: _fadeController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Technique Breakdown", style: AppTypography.h2),
                        const SizedBox(height: 16),
                        ...widget.scoringResult.techniqueBreakdown.entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildTechniqueRow(entry.key, entry.value),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats Row
                  FadeTransition(
                    opacity: _fadeController,
                    child: Row(
                      children: [
                        Expanded(child: _buildStatCard('Duration', '${widget.durationSeconds}s')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('Frames', '${widget.scoringResult.techniqueBreakdown.length} criteria')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  FadeTransition(
                    opacity: _fadeController,
                    child: Column(
                      children: [
                        // Share to Feed (TODO: Phase 3)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Share to feed in Phase 3
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Sharing coming in Phase 3!")),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: AppGradients.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text("SHARE TO FEED", style: AppTypography.button),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Try Again
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/drill/record',
                                arguments: widget.drill,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.glassBorder),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text("TRY AGAIN", style: AppTypography.button.copyWith(color: AppColors.textSecondary)),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Done
                        TextButton(
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          child: Text("Done", style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRing(TierInfo tier) {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        final currentScore = (_scoreAnimation.value * 100).round();
        return SizedBox(
          width: 180,
          height: 180,
          child: CustomPaint(
            painter: _ScoreRingPainter(
              progress: _scoreAnimation.value,
              color: tier.color,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$currentScore',
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 52,
                      color: tier.color,
                    ),
                  ),
                  Text('/ 100', style: AppTypography.bodySmall),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTierBadge(TierInfo tier) {
    final isElite = tier.name == 'Elite';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        gradient: isElite ? AppGradients.gold : null,
        color: isElite ? null : tier.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tier.color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tier.icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            tier.name.toUpperCase(),
            style: AppTypography.h3.copyWith(
              color: isElite ? AppColors.textOnGold : tier.color,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechniqueRow(String name, double score) {
    final tierInfo = TierConstants.getTierFromScore(score.round());
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.h3.copyWith(fontSize: 14)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    backgroundColor: AppColors.glassFill,
                    valueColor: AlwaysStoppedAnimation<Color>(tierInfo.color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${score.round()}',
            style: AppTypography.h2.copyWith(color: tierInfo.color),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(label, style: AppTypography.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.h3),
        ],
      ),
    );
  }
}

/// Paints the animated score ring.
class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ScoreRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background ring
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
