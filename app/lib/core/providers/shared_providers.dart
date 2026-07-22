import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This provider exposes the initialized SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize SharedPreferences in main.dart first');
});

// A standalone state controller to cleanly check and save the onboarding state flag
final onboardingStorageProvider = Provider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingStorageService(prefs);
});

class OnboardingStorageService {
  final SharedPreferences _prefs;
  static const _key = 'has_seen_onboarding';

  OnboardingStorageService(this._prefs);

  // Check if user has already experienced onboarding
  bool checkHasSeenOnboarding() => _prefs.getBool(_key) ?? false;

  // Mark onboarding complete permanently
  Future<bool> markOnboardingComplete() => _prefs.setBool(_key, true);

  // Reset onboarding flag (useful during testing/deletion workflows)
  Future<bool> resetOnboardingFlag() => _prefs.remove(_key);
}