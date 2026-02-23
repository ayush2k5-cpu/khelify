import 'package:khelify_app/core/constants/drill_constants.dart';
import 'package:khelify_app/features/drill/models/drill.dart';

class ExploreService {
  List<Drill> getAllDrills() {
    return DrillConstants.allDrills;
  }

  List<Drill> getDrillsBySport(String sport) {
    if (sport == 'All') return DrillConstants.allDrills;
    return DrillConstants.allDrills.where((d) => d.sport == sport).toList();
  }

  List<Drill> searchDrills(String query, String selectedSport) {
    final base = getDrillsBySport(selectedSport);
    if (query.isEmpty) return base;
    final lower = query.toLowerCase();
    return base
        .where((d) =>
            d.name.toLowerCase().contains(lower) ||
            d.category.toLowerCase().contains(lower) ||
            d.description.toLowerCase().contains(lower))
        .toList();
  }
}
