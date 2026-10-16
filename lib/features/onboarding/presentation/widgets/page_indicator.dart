import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({super.key, required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            width: i == currentIndex ? 28 : 10,              // pilule ou point
            height: 10,
            decoration: BoxDecoration(
              color: i == currentIndex ? colors.onSurface : colors.outline,
              borderRadius: BorderRadius.circular(999),       // bords totalement arrondis
            ),
          ),
      ],
    );
  }
}
