import 'package:flutter/material.dart';
import 'package:ryou_app/features/onboarding/domain/onboarding_step.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.step});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 40,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle
            ),
            child: switch (step) {
            OnboardingStep.welcome => Image.asset(
              'assets/images/poses/pose_salut.png',
            ),
            OnboardingStep.moods => Image.asset(
              'assets/images/poses/pose_roulette.png',
            ),
            OnboardingStep.couple => Image.asset(
              'assets/images/poses/pose_fete.png'
            )  
          },
          )
        ),
        Column(
          spacing: 20,
          children: [
            Text(
              switch (step) {
                OnboardingStep.welcome => "Coucou, moi \nc'est Ryou !",
                OnboardingStep.moods => "Une humeur, un geste",
                OnboardingStep.couple => "Mieux se comprendre, chaque jour",
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!
                  .copyWith(fontSize: 30),
            ),
            Text(
              textAlign: TextAlign.center,
              switch (step) {
                OnboardingStep.welcome =>
                  "Je fais le lien entre vous deux,\nune humeur à la fois.",
                OnboardingStep.moods => "Choisis comment tu te sens en deux secondes. Ton ou ta partenaire le voit aussitôt.",
                OnboardingStep.couple => "Un coup de mou, une bonne nouvelle, une envie de câlin : l’autre est au courant et peut y répondre.",
              },
              style: Theme.of(context).textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
