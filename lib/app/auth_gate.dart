import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryou_app/app/app_step.dart';
import 'package:ryou_app/features/auth/presentation/views/sign_up_screen.dart';
import 'package:ryou_app/features/home/presentation/home_screen.dart';
import 'package:ryou_app/features/onboarding/presentation/view/onboarding_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(appStepProvider, (previous, next) {
      if ((next == AppStep.home || next == AppStep.intro) && previous != next) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
    return switch (ref.watch(appStepProvider)) {
      AppStep.loading => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      AppStep.intro => const OnboardingScreen(),
      AppStep.signedOut => const SignUpScreen(),
      AppStep.home => const HomeScreen(),
    };
  }
}
