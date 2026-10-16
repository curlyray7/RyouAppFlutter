import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryou_app/core/storage/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  const OnboardingRepository({required this.prefs});

  final SharedPreferencesAsync prefs;
  static const _key = "hasSeenIntro";

  Future<bool> get hasSeenIntro async => await prefs.getBool(_key) ?? false;

  Future<void> markIntroSeen() async{
    await prefs.setBool(_key, true);
  }
}

final onboardingRepositoryProvider = Provider((ref) {
  return OnboardingRepository(prefs: ref.watch(sharedPreferencesProvider));
});

final hasSeenIntroProvider = FutureProvider<bool>((ref) {
  return ref.watch(onboardingRepositoryProvider).hasSeenIntro;
});