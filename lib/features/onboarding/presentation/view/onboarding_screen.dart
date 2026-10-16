import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryou_app/features/onboarding/domain/onboarding_step.dart';
import 'package:ryou_app/features/onboarding/presentation/controller/onboarding_controller.dart';
import 'package:ryou_app/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:ryou_app/features/onboarding/presentation/widgets/page_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _OnboardingScreenState();
  }
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();

  Future<void> _onNext() async {
    final controller = ref.read(onboardingControllerProvider.notifier);

    if (controller.isLastPage) {
      await controller.complete();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        actions: currentPage != OnboardingController.pageCount - 1
            ? [
                TextButton(
                  onPressed: () => ref
                      .read(onboardingControllerProvider.notifier)
                      .complete(),
                  child: Text("Passer"),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            spacing: 30,
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => ref
                      .read(onboardingControllerProvider.notifier)
                      .setIndex(index),
                  children: [
                    OnboardingPage(step: OnboardingStep.welcome),
                    OnboardingPage(step: OnboardingStep.moods),
                    OnboardingPage(step: OnboardingStep.couple),
                  ],
                ),
              ),
              PageIndicator(
                count: OnboardingController.pageCount,
                currentIndex: currentPage,
              ),
              FilledButton(
                onPressed: _onNext,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(58),
                ),
                child: Text(currentPage != OnboardingController.pageCount - 1 ? "Suivant" : "Commencer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
