import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khelify_app/features/drill/models/drill.dart';
import '../services/explore_service.dart';

// Service provider
final exploreServiceProvider = Provider<ExploreService>((ref) {
  return ExploreService();
});

// Selected sport filter — 'All' by default
final selectedSportProvider = StateProvider<String>((ref) => 'All');

// Search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered drill list — reacts to both sport filter and search query
final filteredDrillsProvider = Provider<List<Drill>>((ref) {
  final service = ref.watch(exploreServiceProvider);
  final sport = ref.watch(selectedSportProvider);
  final query = ref.watch(searchQueryProvider);
  return service.searchDrills(query, sport);
});
