// lib/core/animations/page_transitions.dart
// Custom page transitions for smooth navigation

import 'package:flutter/material.dart';

/// Fade and slide transition for page navigation
class FadeSlideTransition extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  FadeSlideTransition({
    required this.page,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.05);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
        );
}

/// Scale and fade transition for dialogs and modals
class ScaleFadeTransition extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  ScaleFadeTransition({
    required this.page,
    this.duration = const Duration(milliseconds: 250),
  }) : super(
          opaque: false,
          barrierColor: Colors.black54,
          barrierDismissible: true,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeOutBack;

            var scaleTween = Tween(begin: 0.9, end: 1.0).chain(
              CurveTween(curve: curve),
            );
            var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: Curves.easeOut),
            );

            return ScaleTransition(
              scale: animation.drive(scaleTween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
        );
}

/// Shared axis transition for related content
class SharedAxisTransition extends PageRouteBuilder {
  final Widget page;
  final SharedAxisDirection direction;
  final Duration duration;

  SharedAxisTransition({
    required this.page,
    this.direction = SharedAxisDirection.horizontal,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurveTween(curve: Curves.easeOutCubic);

            Offset beginOffset;
            switch (direction) {
              case SharedAxisDirection.horizontal:
                beginOffset = const Offset(1.0, 0.0);
                break;
              case SharedAxisDirection.vertical:
                beginOffset = const Offset(0.0, 1.0);
                break;
            }

            var slideTween =
                Tween(begin: beginOffset, end: Offset.zero).chain(curve);
            var fadeTween = Tween(begin: 0.0, end: 1.0).chain(curve);

            return SlideTransition(
              position: animation.drive(slideTween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
        );
}

enum SharedAxisDirection {
  horizontal,
  vertical,
}
