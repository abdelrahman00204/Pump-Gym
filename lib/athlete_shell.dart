import 'package:flutter/material.dart';
import 'package:pump_gym/bottom_nav.dart';
import 'package:pump_gym/nav_icons.dart';
import 'package:pump_gym/side_nav.dart';
import 'package:pump_gym/theme/breakpoints.dart';
import 'package:pump_gym/top_nav.dart';



/// True when the desktop top nav is showing. On those layouts the top nav
/// already provides back / logo / language / bell / avatar (or logout), so a
/// screen should NOT render its own TopBar / AdminTopBar. Use it as a
/// collection-if:
///
///   if (!showsDesktopTopNav(context)) const AdminTopBar(),
bool showsDesktopTopNav(BuildContext context) =>
    pumpLayoutSizeOf(context) == PumpLayoutSize.expanded;

/// Wraps a screen's body with the right navigation for the window width
/// (spec §2.9):
///   compact  (< 768)       bottom tab bar
///   medium   (768 - 1023)  side rail + the screen's own top bar
///   expanded (>= 1024)     top nav bar (replaces the top bar), capped content
///
/// [navSet] decides which destinations show. It defaults to the athlete set;
/// use AdminShell for admin screens.
class AthleteShell extends StatelessWidget {
  final Widget body;
  final PumpNavSet navSet;
  const AthleteShell({
    super.key,
    required this.body,
    this.navSet = athleteNavSet,
  });

  @override
  Widget build(BuildContext context) {
    switch (pumpLayoutSizeOf(context)) {
      case PumpLayoutSize.compact:
        return Scaffold(
          body: SafeArea(child: body),
          bottomNavigationBar: BottomNav(navSet: navSet),
        );

      case PumpLayoutSize.medium:
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                PumpSideNav(navSet: navSet),
                Expanded(child: _CappedContent(child: body)),
              ],
            ),
          ),
        );

      case PumpLayoutSize.expanded:
        return Scaffold(
          body: Column(
            children: [
              PumpTopNav(navSet: navSet),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: _CappedContent(child: body),
                ),
              ),
            ],
          ),
        );
    }
  }
}

class _CappedContent extends StatelessWidget {
  final Widget child;
  const _CappedContent({required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: pumpContentMaxWidth),
        child: child,
      ),
    );
  }
}