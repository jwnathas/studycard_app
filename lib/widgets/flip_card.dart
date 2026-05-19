import 'dart:math';
import 'package:flutter/material.dart';

class FlipCard extends StatelessWidget {
  final Widget front;
  final Widget back;
  final bool isFlipped;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    required this.isFlipped,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: isFlipped ? 180 : 0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack, // Curva suave com um leve "balanço"
      builder: (context, double value, child) {
        // Decide qual face mostrar baseado no ângulo
        final content = value <= 90
            ? front
            : Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(pi),
                child: back,
              );

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspectiva 3D
            ..rotateY(value * pi / 180),
          child: content,
        );
      },
    );
  }
}
