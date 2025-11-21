import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../themes/khelify_theme.dart';

// KHOJJOO SCREEN
// Map View + Games Schedule

class KhojjooScreen extends StatefulWidget {
  const KhojjooScreen({Key? key}) : super(key: key);

  @override
  State<KhojjooScreen> createState() => _KhojjooScreenState();
}

class _KhojjooScreenState extends State<KhojjooScreen> {
  int _khojjooTabIndex = 0; // 0 = Map, 1 = Games Schedule
  int _selectedScheduleDateIndex = 0; // 0 = Today, 1 = Tomorrow, etc.

  final Completer<GoogleMapController> _mapController = Completer();

  static final CameraPosition _kInitialCamera = CameraPosition(
    target: LatLng(20.5937, 78.9629), // Center of India
    zoom: 5.5,
  );

  final Set<Marker> _kMarkers = {
    Marker(
      markerId: MarkerId('delhi_academy'),
      position: LatLng(28.6139, 77.2090),
      infoWindow: InfoWindow(title: 'Delhi Sports Academy'),
    ),
    Marker(
      markerId: MarkerId('mumbai_academy'),
      position: LatLng(19.0760, 72.8777),
      infoWindow: InfoWindow(title: 'Mumbai Training Centre'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Content Layer (Map or Schedule)
        IndexedStack(
          index: _khojjooTabIndex,
          children: [
            _buildKhojjooMapView(),     // Index 0
            _buildGamesScheduleView(),  // Index 1
          ],
        ),

        // Top Tabs Layer (Floating Header)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: _buildKhojjooTopTabs(),
          ),
        ),
      ],
    );
  }

  // 1. Top Tab Bar
  Widget _buildKhojjooTopTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KhelifyColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabItem(0, "Khojjoo"),
          Container(width: 1, color: KhelifyColors.glassBorder), // Divider
          _buildTabItem(1, "Games Schedule"),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _khojjooTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _khojjooTabIndex = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? KhelifyColors.glassBorder : Colors.transparent,
            borderRadius: index == 0
                ? const BorderRadius.horizontal(left: Radius.circular(11))
                : const BorderRadius.horizontal(right: Radius.circular(11)),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: isSelected
                ? KhelifyTypography.button.copyWith(color: KhelifyColors.championGold)
                : KhelifyTypography.bodyMedium.copyWith(color: KhelifyColors.textSecondary),
          ),
        ),
      ),
    );
  }

  // 2. Map View (with Draggable Sheet)
  Widget _buildKhojjooMapView() {
    return Stack(
      children: [
        // Map Background
        Positioned.fill(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kInitialCamera,
            markers: _kMarkers,
            myLocationEnabled: false,
            compassEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              if (!_mapController.isCompleted) {
                _mapController.complete(controller);
              }
            },
            padding: const EdgeInsets.only(top: 100), // Padding for tabs
          ),
        ),

        // Draggable Bottom Sheet
        DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.15,
          maxChildSize: 0.85,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: KhelifyColors.cardDark,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
                border: Border(
                  top: BorderSide(color: KhelifyColors.glassBorder, width: 1),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.zero,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: KhelifyColors.textTertiary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nearby Academies",
                          style: KhelifyTypography.heading2,
                        ),
                        const SizedBox(height: 16),
                        _buildAcademyItem("Delhi Sports Academy", "4.5 km • Cricket", "4.8"),
                        _buildAcademyItem("Mumbai Training Centre", "12 km • Football", "4.6"),
                        _buildAcademyItem("Bangalore Elite Club", "8.2 km • Badminton", "4.9"),
                        _buildAcademyItem("Pune Smashers", "3.1 km • Tennis", "4.5"),
                        _buildAcademyItem("Hyderabad Hoopsters", "5.5 km • Basketball", "4.7"),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // 3. Games Schedule View
  Widget _buildGamesScheduleView() {
    return Container(
      padding: const EdgeInsets.only(top: 80), // Top tabs height + padding
      child: Column(
        children: [
          // Horizontal Date Strip
          _buildCalendarStrip(),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _getGamesForSelectedDate(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarStrip() {
    final days = ['THU', 'FRI', 'SAT', 'SUN', 'MON', 'TUE', 'WED'];
    final dates = ['15', '16', '17', '18', '19', '20', '21'];

    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 7,
        itemBuilder: (context, index) {
          final isSelected = _selectedScheduleDateIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedScheduleDateIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? KhelifyColors.championGold : KhelifyColors.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? KhelifyColors.championGold : KhelifyColors.border,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: KhelifyColors.championGold.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    days[index],
                    style: KhelifyTypography.caption.copyWith(
                      color: isSelected ? Colors.black : KhelifyColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dates[index],
                    style: KhelifyTypography.heading3.copyWith(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _getGamesForSelectedDate() {
    // Mock Data based on date
    if (_selectedScheduleDateIndex == 0) {
      // Today
      return [
        _buildSectionHeader("LIVE NOW 🔥"),
        _buildGameCard("Premier League", "Delhi Dynamos vs Mumbai", "LIVE", "Football", isLive: true),
        const SizedBox(height: 24),
        _buildSectionHeader("UPCOMING TODAY"),
        _buildGameCard("U-19 Selection", "Rohini Complex • Court 1", "04:00 PM", "Cricket"),
        _buildGameCard("Badminton Singles", "Quarter Finals • Arena 2", "06:30 PM", "Badminton"),
        const SizedBox(height: 100),
      ];
    } else if (_selectedScheduleDateIndex == 1) {
      // Tomorrow
      return [
        _buildSectionHeader("TOMORROW"),
        _buildGameCard("Inter-School League", "St. Marks vs DPS", "09:00 AM", "Basketball"),
        _buildGameCard("Tennis Open", "Semi-Finals • Clay Court", "02:00 PM", "Tennis"),
        _buildGameCard("Practice Match", "Academy A vs Academy B", "05:00 PM", "Football"),
        const SizedBox(height: 100),
      ];
    } else {
      // Other dates (Empty state)
      return [
        const SizedBox(height: 60),
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: KhelifyColors.inputBackground,
                ),
                child: const Icon(Icons.event_available, size: 40, color: KhelifyColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Text(
                "No games scheduled",
                style: KhelifyTypography.bodyLarge.copyWith(color: KhelifyColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                "Check back later for updates",
                style: KhelifyTypography.bodySmall,
              ),
            ],
          ),
        ),
      ];
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: KhelifyTypography.bodySmall.copyWith(
          color: KhelifyColors.textSecondary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildGameCard(String title, String subtitle, String time, String sport, {bool isLive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KhelifyColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLive ? KhelifyColors.persianRed.withOpacity(0.5) : KhelifyColors.border,
        ),
        boxShadow: isLive
            ? [
                BoxShadow(
                  color: KhelifyColors.persianRed.withOpacity(0.1),
                  blurRadius: 12,
                )
              ]
            : [],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: isLive ? KhelifyColors.persianRed : KhelifyColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: isLive
                  ? const Text("LIVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          time.split(' ')[0],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          time.split(' ').length > 1 ? time.split(' ')[1] : '',
                          style: TextStyle(color: KhelifyColors.textSecondary, fontSize: 10),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      sport.toUpperCase(),
                      style: TextStyle(
                        color: isLive ? KhelifyColors.persianRed : KhelifyColors.sapphireBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (isLive) ...[
                      const SizedBox(width: 6),
                      Container(width: 4, height: 4, decoration: BoxDecoration(color: KhelifyColors.persianRed, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text("IN PROGRESS", style: TextStyle(color: KhelifyColors.textTertiary, fontSize: 10)),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(title, style: KhelifyTypography.heading3.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: KhelifyTypography.bodySmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: KhelifyColors.textTertiary, size: 20),
        ],
      ),
    );
  }

  Widget _buildAcademyItem(String name, String details, String rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: KhelifyColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KhelifyColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: KhelifyColors.blueGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.sports_score, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: KhelifyTypography.heading3.copyWith(fontSize: 15)),
                const SizedBox(height: 4),
                Text(details, style: KhelifyTypography.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: KhelifyColors.championGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: KhelifyColors.championGold),
                    const SizedBox(width: 2),
                    Text(rating, style: TextStyle(color: KhelifyColors.championGold, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
