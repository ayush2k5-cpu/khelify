import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../themes/khelify_theme.dart';
import '../models/post.dart';
import '../services/mock_data_service.dart';

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
  int _selectedSportIndex = 0;

  late List<Drill> _footballDrills;
  late List<Drill> _badmintonDrills;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _footballDrills = MockDataService.getDrillsBySport('Football');
    _badmintonDrills = MockDataService.getDrillsBySport('Badminton');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleSportTabChange(int index) {
    setState(() {
      _selectedSportIndex = index;
      _tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sports = ['Football', 'Badminton'];
    final allDrills = [_footballDrills, _badmintonDrills];

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
          _buildTabBar(sports),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: sports.map((_) {
                final drills = allDrills[_selectedSportIndex];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DrillCarousel(
                    drills: drills,
                    onDrillSelected: (drill) {
                      widget.onDrillSelected?.call(drill);
                      Navigator.pop(context);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildTabBar(List<String> sports) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        labelColor: KhelifyColors.white,
        unselectedLabelColor: KhelifyColors.textTertiary,
        labelStyle: KhelifyTypography.heading3,
        indicatorColor: KhelifyColors.sapphireBlue,
        indicatorWeight: 3,
        onTap: _handleSportTabChange,
        tabs: sports.map((s) => Tab(text: s.toUpperCase())).toList(),
      ),
    );
  }
}

class DrillCarousel extends StatefulWidget {
  final List<Drill> drills;
  final void Function(Drill) onDrillSelected;

  const DrillCarousel({
    super.key,
    required this.drills,
    required this.onDrillSelected,
  });

  @override
  State<DrillCarousel> createState() => _DrillCarouselState();
}

class _DrillCarouselState extends State<DrillCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  final Map<String, Color> difficultyColors = {
    'easy': Colors.greenAccent,
    'medium': Colors.orangeAccent,
    'hard': Colors.redAccent,
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _difficultyColor(String diff) {
    return difficultyColors[diff.toLowerCase()] ?? Colors.blueAccent;
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _goToNextPage() {
    if (_currentPage < widget.drills.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 420,
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.drills.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  bool active = index == _currentPage;
                  return TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    tween: Tween<double>(
                        begin: active ? 1.0 : 0.9, end: active ? 1.0 : 0.9),
                    curve: Curves.easeOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: DrillCard(
                      drill: widget.drills[index],
                      difficultyColor:
                          _difficultyColor(widget.drills[index].difficulty),
                    ),
                  );
                },
              ),
            ),
            // Arrow left
            Positioned(
              left: 4,
              child: IconButton(
                iconSize: 38,
                color:
                    _currentPage == 0 ? Colors.grey.shade400 : Colors.orange,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: _currentPage == 0 ? null : _goToPreviousPage,
              ),
            ),
            // Arrow right
            Positioned(
              right: 4,
              child: IconButton(
                iconSize: 38,
                color: _currentPage == widget.drills.length - 1
                    ? Colors.grey.shade400
                    : Colors.orange,
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                onPressed: _currentPage == widget.drills.length - 1
                    ? null
                    : _goToNextPage,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.drills.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: _currentPage == index ? 14 : 8,
              height: _currentPage == index ? 14 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentPage == index ? Colors.orange : Colors.grey[300],
              ),
            );
          }),
        ),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: () {
            widget.onDrillSelected(widget.drills[_currentPage]);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            shadowColor: Colors.orangeAccent.shade200,
            elevation: 12,
          ),
          child: const Text(
            "Start Recording",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// --- Glassmorphic & vibrant DrillCard ---

class DrillCard extends StatelessWidget {
  final Drill drill;
  final Color difficultyColor;

  const DrillCard({
    super.key,
    required this.drill,
    required this.difficultyColor,
  });

  @override
  Widget build(BuildContext context) {
    // Vibrant colored glass glow and border
    final Color glow = difficultyColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: glow.withOpacity(0.49), width: 2.2),
              boxShadow: [
                BoxShadow(
                  color: glow.withOpacity(0.12),
                  blurRadius: 40,
                  spreadRadius: 6,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 22),
                // Vibrant avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: glow.withOpacity(0.18),
                    boxShadow: [
                      BoxShadow(
                        color: glow.withOpacity(0.38),
                        blurRadius: 33,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(27),
                  child: Text(
                    drill.icon,
                    style: const TextStyle(
                        fontSize: 54, shadows: [
                      Shadow(
                          blurRadius: 10,
                          color: Colors.black38,
                          offset: Offset(0, 6)),
                    ]),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  drill.name,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF22222C),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${drill.estimatedDuration}s",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: glow.withOpacity(0.19),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Text(
                        drill.difficulty,
                        style: TextStyle(
                          color: glow.darken(0.18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    drill.description ?? '',
                    style: const TextStyle(
                        fontSize: 15.5, color: Color(0xFF22232C)),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------ Color darken extension -----

extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness(
        (hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
