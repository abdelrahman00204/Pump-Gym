import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Binding transition rule: every screen change in the app uses this one
/// 300ms easeInOut transition — no per-route custom curves or durations.
/// Wrap every GoRoute's `pageBuilder` with [pumpPage] instead of returning
/// a bare widget, or GoRouter falls back to the platform's default
/// transition (Cupertino slide / Material fade-through) instead of this one.
const Duration kPumpPageTransitionDuration = Duration(milliseconds: 300);
const Curve kPumpPageTransitionCurve = Curves.easeInOut;

CustomTransitionPage<T> pumpPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: kPumpPageTransitionDuration,
    reverseTransitionDuration: kPumpPageTransitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: kPumpPageTransitionCurve,
        reverseCurve: kPumpPageTransitionCurve,
      );
      // Fade + a small upward settle reads as "ease" rather than a hard cut,
      // without implying directional navigation (back/forward) the way a
      // full slide transition would — appropriate for a bottom-bar /
      // sidebar-rail nav structure where screens aren't a linear stack.
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
