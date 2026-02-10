import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../themes/khelify_theme.dart';
import '../models/post.dart';
import '../services/mock_data_service.dart';

// RECORD MODAL SHEET – TIME TO GRIND

class RecordModalSheet extends StatefulWidget {
  final Function(Drill)? onDrillSelected;

  const RecordModalSheet({
    super.key,
    this.onDrillSelected,
  });

  @override
  State<RecordModalSheet> createState() => _RecordModalSheetState();
}

class _RecordModalSheetState extends State<RecordModalSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // sport selector inside SPORTS tab
  final List<String> _sports = ['Football', 'Badminton'];
  int _selectedSportIndex = 0;
  late PageController _pageController;
  Drill? _selectedDrill;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(viewportFraction: 0.86);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: KhelifyColors.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildDragHandle(),
          _buildHeroTitle(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSportsTab(),
                _buildEsportsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== DRAG HANDLE ==========

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: KhelifyColors.textTertiary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // ========== HERO TITLE ==========

  Widget _buildHeroTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          ShaderMask(
            shaderCallback: (bounds) {
              return KhelifyColors.goldGradient.createShader(bounds);
            },
            child: Text(
              'TIME TO GRIND!',
              style: KhelifyTypography.displayLarge.copyWith(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text('🔥', style: TextStyle(fontSize: 28)),
        ],
      ),
    );
  }

  // ========== TAB BAR (SPORTS | ESPORTS) ==========

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        labelColor: KhelifyColors.white,
        unselectedLabelColor: KhelifyColors.textTertiary,
        labelStyle: KhelifyTypography.heading3,
        indicatorColor: KhelifyColors.sapphireBlue,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'SPORTS'),
          Tab(text: 'ESPORTS'),
        ],
      ),
    );
  }

  // ========== SPORTS TAB – Starbucks-style carousel ==========

  Widget _buildSportsTab() {
    final String sport = _sports[_selectedSportIndex];
    final List<Drill> drills = MockDataService.getDrillsBySport(sport);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        _buildSportSelector(),
        const SizedBox(height: 8),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: drills.length,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _selectedDrill = drills[index];
              });
            },
            itemBuilder: (context, index) {
              final Drill drill = drills[index];

              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double page = 0;
                  if (_pageController.position.haveDimensions) {
                    page = _pageController.page ??
                        _pageController.initialPage.toDouble();
                  }
                  final double distance = (index - page).abs();
                  final double scale =
                      1 - (distance * 0.08).clamp(0.0, 0.15); // subtle scale
                  final double translateY = 12 * distance;

                  return Transform.translate(
                    offset: Offset(0, translateY),
                    child: Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                  );
                },
                child: _buildDrillCard(drill),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildPageDots(drills.length),
        const SizedBox(height: 16),
        if (_selectedDrill != null) _buildStartButton(),
        const SizedBox(height: 16),
      ],
    );
  }

  // small segmented sport selector (Football / Badminton)
  Widget _buildSportSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: KhelifyColors.cardDark,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: KhelifyColors.border),
        ),
        child: Row(
          children: List.generate(_sports.length, (index) {
            final bool isActive = index == _selectedSportIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (_selectedSportIndex == index) return;
                  setState(() {
                    _selectedSportIndex = index;
                    _selectedDrill = null;
                  });
                  _pageController.jumpToPage(0);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color:
                        isActive ? KhelifyColors.sapphireBlue : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      _sports[index],
                      style: KhelifyTypography.bodySmall.copyWith(
                        color:
                            isActive ? Colors.white : KhelifyColors.textSecondary,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // big white drill card with emoji & details
  Widget _buildDrillCard(Drill drill) {
    final bool isSelected = _selectedDrill?.id == drill.id;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: KhelifyColors.championGold
                    .withOpacity(isSelected ? 0.7 : 0.4),
                width: isSelected ? 2.2 : 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: KhelifyColors.championGold.withOpacity(0.16),
                  blurRadius: 30,
                  spreadRadius: 4,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              children: [
                // emoji “product” bubble
                Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: KhelifyColors.championGold.withOpacity(0.18),
                    boxShadow: [
                      BoxShadow(
                        color: KhelifyColors.championGold.withOpacity(0.45),
                        blurRadius: 30,
                        spreadRadius: 2,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Text(
                    drill.icon,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
                const SizedBox(height: 20),
                // content (title, meta, description)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Column(
                    key: ValueKey(drill.id),
                    children: [
                      Text(
                        drill.name,
                        textAlign: TextAlign.center,
                        style: KhelifyTypography.heading2.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${drill.estimatedDuration}s',
                            style: KhelifyTypography.bodySmall.copyWith(
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(drill.difficulty)
                                  .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              drill.difficulty,
                              style: KhelifyTypography.bodySmall.copyWith(
                                color: _getDifficultyColor(drill.difficulty),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        drill.description ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: KhelifyTypography.bodyMedium.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // dots under the carousel
  Widget _buildPageDots(int length) {
    final double page =
        _pageController.hasClients ? (_pageController.page ?? 0) : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final bool isActive = (page.round() == index);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 12 : 7,
          height: isActive ? 12 : 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? KhelifyColors.championGold
                : KhelifyColors.textTertiary.withOpacity(0.5),
          ),
        );
      }),
    );
  }

  // ========== ESPORTS TAB – COMING SOON ==========

  Widget _buildEsportsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    KhelifyColors.championGold.withOpacity(0.2),
                    KhelifyColors.sapphireBlue.withOpacity(0.2),
                  ],
                ),
                border: Border.all(
                  color: KhelifyColors.championGold,
                  width: 2,
                ),
              ),
              child: Icon(
                PhosphorIcons.gameController(PhosphorIconsStyle.fill),
                size: 64,
                color: KhelifyColors.championGold,
              ),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) {
                return KhelifyColors.goldGradient.createShader(bounds);
              },
              child: Text(
                'COMING SOON!',
                style: KhelifyTypography.heading1.copyWith(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Esports drills will include:',
              style: KhelifyTypography.bodyLarge.copyWith(
                color: KhelifyColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureItem('🎯 BGMI Aim Training'),
                _buildFeatureItem('🔫 Valorant Flick Practice'),
                _buildFeatureItem('💥 CS2 Spray Control'),
                _buildFeatureItem('🎮 And more...'),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('You\'ll be notified when Esports launches!'),
                    backgroundColor: KhelifyColors.sapphireBlue,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: KhelifyColors.sapphireBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'NOTIFY ME',
                style: KhelifyTypography.button,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: KhelifyTypography.bodyMedium,
      ),
    );
  }

  // ========== START RECORDING BUTTON ==========

  Widget _buildStartButton() {
    final drill = _selectedDrill!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            "You'll record: ${drill.name}",
            textAlign: TextAlign.center,
            style: KhelifyTypography.bodySmall.copyWith(
              color: KhelifyColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: KhelifyColors.goldGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: KhelifyColors.championGold.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                widget.onDrillSelected?.call(drill);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'START RECORDING',
                style: KhelifyTypography.button.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== HELPERS ==========

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return KhelifyColors.successGreen;
      case 'medium':
        return KhelifyColors.warningOrange;
      case 'hard':
        return KhelifyColors.persianRed;
      default:
        return KhelifyColors.textSecondary;
    }
  }
}

// helper to show the modal from outside
void showRecordModal(BuildContext context, {Function(Drill)? onDrillSelected}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => RecordModalSheet(
      onDrillSelected: onDrillSelected,
    ),
  );
}
