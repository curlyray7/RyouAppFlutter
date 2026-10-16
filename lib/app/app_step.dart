import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryou_app/core/firebase/firebase_providers.dart';
import 'package:ryou_app/features/auth/presentation/controllers/sign_up_controller.dart';
import 'package:ryou_app/features/onboarding/data/onboarding_repository.dart';

enum AppStep { loading, intro, signedOut, home }

final appStepProvider = Provider<AppStep>((ref) {
  final hasSeenIntro = ref.watch(hasSeenIntroProvider);
  final authState = ref.watch(authStateProvider);
  final isSigningUp = ref.watch(signUpControllerProvider).isLoading;

  if (!hasSeenIntro.hasValue || authState.isLoading) return AppStep.loading;
  if (hasSeenIntro.value != true) return AppStep.intro;
  if (authState.value == null || isSigningUp) return AppStep.signedOut;
  return AppStep.home;
  
});