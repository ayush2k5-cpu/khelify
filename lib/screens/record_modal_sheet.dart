import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../themes/khelify_theme.dart';
import '../models/post.dart';
import '../services/mock_data_service.dart';

// ══════════════════════════════════════════════════════════
// RECORD MODAL SHEET
// Swipe-up from floating button
// Sports/Esports tabs (Twitter X style)
// ══════════════════════════════════════════════════════════

class RecordModalSheet extends StatefulWidget {
  final Function(Drill)? onDrillSelected;

  const RecordModalSheet({
    Key? key,
    this.onDrillSelected,
  }) : super(key: key);

  @override
  State<RecordModalSheet> createState() => _RecordModalSheetState();
}

class _RecordModalSheetState extends State<RecordModalSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedSport;
  Drill? selectedDrill;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: KhelifyColors.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          _buildDragHandle(),
          
          // Hero Title
          _buildHeroTitle(),
          
          // Tab Bar (Sports | Esports)
          _buildTabBar(),
          
          // Tab Views
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
      margin: EdgeInsets.only(top: 12, bottom: 8),
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
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '🔥',
            style: TextStyle(fontSize: 28),
          ),
          SizedBox(width: 12),
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
          SizedBox(width: 12),
          Text(
            '🔥',
            style: TextStyle(fontSize: 28),
          ),
        ],
      ),
    );
  }

  // ========== TAB BAR (Twitter X Style) ==========
  
  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        labelColor: KhelifyColors.white,
        unselectedLabelColor: KhelifyColors.textTertiary,
        labelStyle: KhelifyTypography.heading3,
        indicatorColor: KhelifyColors.sapphireBlue,
        indicatorWeight: 3,
        tabs: [
          Tab(text: 'SPORTS'),
          Tab(text: 'ESPORTS'),
        ],
      ),
    );
  }

  // ========== SPORTS TAB ==========
  
  Widget _buildSportsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Football Section
          _buildSportSection(
            sport: 'Football',
            icon: '⚽',
            drills: MockDataService.getDrillsBySport('Football'),
          ),
          
          SizedBox(height: 24),
          
          // Badminton Section
          _buildSportSection(
            sport: 'Badminton',
            icon: '🏸',
            drills: MockDataService.getDrillsBySport('Badminton'),
          ),
          
          SizedBox(height: 32),
          
          // Start Recording Button (if drill selected)
          if (selectedDrill != null)
            _buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildSportSection({
    required String sport,
    required String icon,
    required List<Drill> drills,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sport Header
        Row(
          children: [
            Text(icon, style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              sport.toUpperCase(),
              style: KhelifyTypography.heading2,
            ),
          ],
        ),
        
        SizedBox(height: 12),
        
        // Drill Cards
        ...drills.map((drill) => _buildDrillCard(drill)).toList(),
      ],
    );
  }

  Widget _buildDrillCard(Drill drill) {
    final isSelected = selectedDrill?.id == drill.id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDrill = drill;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? KhelifyColors.sapphireBlue.withOpacity(0.2)
              : KhelifyColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? KhelifyColors.sapphireBlue 
                : KhelifyColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected 
                    ? KhelifyColors.sapphireBlue 
                    : KhelifyColors.border,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  drill.icon,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            
            SizedBox(width: 16),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drill.name,
                    style: KhelifyTypography.heading3,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${drill.estimatedDuration}s',
                        style: KhelifyTypography.bodySmall,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '•',
                        style: KhelifyTypography.bodySmall,
                      ),
                      SizedBox(width: 8),
                      Text(
                        drill.difficulty,
                        style: KhelifyTypography.bodySmall.copyWith(
                          color: _getDifficultyColor(drill.difficulty),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Checkmark
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: KhelifyColors.sapphireBlue,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  // ========== ESPORTS TAB (Coming Soon) ==========
  
  Widget _buildEsportsTab() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Game Controller Icon
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
            
            SizedBox(height: 24),
            
            // Coming Soon Title
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
            
            SizedBox(height: 16),
            
            // Description
            Text(
              'Esports drills will include:',
              style: KhelifyTypography.bodyLarge.copyWith(
                color: KhelifyColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 16),
            
            // Features List
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureItem('🎯 BGMI Aim Training'),
                _buildFeatureItem('🔫 Valorant Flick Practice'),
                _buildFeatureItem('💥 CS2 Spray Control'),
                _buildFeatureItem('🎮 And more...'),
              ],
            ),
            
            SizedBox(height: 32),
            
            // Notify Button
            ElevatedButton(
              onPressed: () {
                // TODO: Add to notification list
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You\'ll be notified when Esports launches!'),
                    backgroundColor: KhelifyColors.sapphireBlue,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: KhelifyColors.sapphireBlue,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: KhelifyTypography.bodyMedium,
      ),
    );
  }

  // ========== START RECORDING BUTTON ==========
  
  Widget _buildStartButton() {
    return Container(
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
          if (selectedDrill != null) {
            widget.onDrillSelected?.call(selectedDrill!);
            Navigator.pop(context);
          }
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

// ══════════════════════════════════════════════════════════
// HELPER: Show Modal Sheet
// ══════════════════════════════════════════════════════════

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