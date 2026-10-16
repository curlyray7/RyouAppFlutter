import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryou_app/features/onboarding/data/onboarding_repository.dart';

class OnboardingController extends Notifier<int> {
  static const pageCount = 3;

  bool get isLastPage => state == pageCount - 1;

  @override
  build() => 0;

  void setIndex(int index) {
    state = index;
  }

  Future<void> complete() async {
    final repository = ref.read(onboardingRepositoryProvider);

    await repository.markIntroSeen(); // 1. on appelle la méthode du repository

    if (!ref.mounted) return; // 2. le controller existe-t-il encore ?

    ref.invalidate(
      hasSeenIntroProvider,
    ); // 3. AuthGate relit la valeur et change d'écran
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, int>(() => OnboardingController());
