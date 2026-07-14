import 'package:app/features/home/data/state/recent_search_state.dart';
import 'package:flutter_riverpod/legacy.dart';

final recentSearchProvider = StateNotifierProvider<RecentSearchNotifier, List<String>>((ref) {
  return RecentSearchNotifier();
});