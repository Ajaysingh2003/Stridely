import 'package:app/features/home/data/service/recent_search_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';



class RecentSearchNotifier extends StateNotifier<List<String>> {
  final _service = RecentSearchService();

  RecentSearchNotifier() : super([]) { _load(); }

  Future<void> _load() async {
    state = await _service.getSearches();
  }

  Future<void> addSearch(String query) async {
    
  final trimmedQuery = query.trim();
  if (trimmedQuery.isEmpty) return;

  final prefs = await SharedPreferences.getInstance();
  
  // 1. Get current list
  List<String> searches = prefs.getStringList('recent_searches') ?? [];
  
  // 2. Remove if it already exists (so we can move it to the top)
  searches.remove(trimmedQuery);
  
  // 3. Add to the top of the list
  searches.insert(0, trimmedQuery);
  
  // 4. Keep only the last 10 searches to save storage
  if (searches.length > 10) {
    searches = searches.sublist(0, 10);
  }
  
  // 5. Save back to storage
  await prefs.setStringList('recent_searches', searches);
  
  // 6. Update the provider state so the UI refreshes immediately
  state = searches;
}

  Future<void> clear() async {
    await _service.clearSearches();
    state = [];
  }
}