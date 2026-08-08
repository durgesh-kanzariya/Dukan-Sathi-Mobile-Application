import 'package:flutter/material.dart';

/// Optimized, high-performance PageRouteBuilder for silky 60-120 FPS Auth transitions.
class SmoothAuthPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SmoothAuthPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            // Lightweight, GPU-accelerated Slide + Fade
            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.04, 0.0),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
}
