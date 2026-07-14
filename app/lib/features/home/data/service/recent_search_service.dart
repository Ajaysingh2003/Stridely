import 'package:shared_preferences/shared_preferences.dart';
class RecentSearchService {
  static const _key = 'recent_searches';

  Future<List<String>> getSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> addSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> searches = prefs.getStringList(_key) ?? [];
    
    // Keep only unique searches and move new ones to the top
    searches.remove(query);
    searches.insert(0, query);
    
    // Limit to 10 items
    if (searches.length > 10) searches = searches.sublist(0, 10);
    
    await prefs.setStringList(_key, searches);
  }

  Future<void> clearSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}