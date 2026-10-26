import 'package:flutter/material.dart';
import 'package:pump_gym/constants/app_routes.dart';

/// Max width of page content on medium/expanded layouts. The desktop top nav
/// and the page body both use this so their edges line up.
const double pumpContentMaxWidth = 1280;

class PumpNavItem {
  final IconData icon;
  final String label;
  final String route;
  const PumpNavItem(this.icon, this.label, this.route);
}

/// A complete set of destinations for one side of the app (athlete or admin).
/// BottomNav, PumpSideNav and PumpTopNav all take a [PumpNavSet], so the
/// destinations are defined exactly once, here.
class PumpNavSet {
  final List<PumpNavItem> items;

  /// Where tapping the logo goes.
  final String homeRoute;

  /// Admin sets show an "ADMIN" tag and a logout button instead of the
  /// athlete profile avatar in the desktop top nav.
  final bool isAdmin;

  const PumpNavSet({
    required this.items,
    required this.homeRoute,
    this.isAdmin = false,
  });

  /// Index of the destination matching [location], or -1 when none matches
  /// (for example on the athlete profile screen). Sub-routes count as a match,
  /// so `/walk-in/scan` highlights "Walk-in".
  int indexOf(String location) => items.indexWhere(
        (item) => location == item.route || location.startsWith('${item.route}/'),
      );
}

const PumpNavSet athleteNavSet = PumpNavSet(
  homeRoute: AppRoutes.lobby,
  items: [
    PumpNavItem(Icons.home, 'Lobby', AppRoutes.lobby),
    PumpNavItem(Icons.calendar_today_outlined, 'Plans', AppRoutes.plans),
    PumpNavItem(Icons.fitness_center, 'Machines', AppRoutes.catalog),
    PumpNavItem(Icons.emoji_events_outlined, 'Community', AppRoutes.community),
    PumpNavItem(Icons.history, 'History', AppRoutes.history),
  ],
);

// Icons are the same ones AdminBottomNav used before. Swap them here if you
// want admin-specific icons (e.g. Icons.dashboard_outlined for Dashboard).
const PumpNavSet adminNavSet = PumpNavSet(
  homeRoute: AppRoutes.dashboard,
  isAdmin: true,
  items: [
    PumpNavItem(Icons.home_outlined, 'Dashboard', AppRoutes.dashboard),
    PumpNavItem(Icons.calendar_today_outlined, 'Protocols', AppRoutes.protocols),
    PumpNavItem(Icons.fitness_center, 'Athletes', AppRoutes.athletes),
    PumpNavItem(Icons.emoji_events_outlined, 'Groups', AppRoutes.groups),
    PumpNavItem(Icons.history, 'Walk-in', AppRoutes.walkIn),
  ],
);