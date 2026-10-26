import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/nav_icons.dart';
import 'package:pump_gym/theme/pump_theme.dart';
import 'package:pump_gym/theme/theme_provider.dart';

/// Tablet navigation (medium layout, 768 <= width < 1024): icons + labels.
///
/// Unlike [PumpTopNav], this does NOT replace the per-screen top bar. The rail
/// has no avatar, language, bell or logout, so each screen keeps its own
/// TopBar / AdminTopBar at this size.
class PumpSideNav extends ConsumerWidget {
  final PumpNavSet navSet;
  const PumpSideNav({super.key, required this.navSet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final location = GoRouterState.of(context).matchedLocation;
    final index = navSet.indexOf(location);

    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        border: Border(right: BorderSide(color: p.border)),
      ),
      child: NavigationRail(
        backgroundColor: Colors.transparent,
        // null = nothing highlighted (e.g. on the athlete profile screen)
        selectedIndex: index < 0 ? null : index,
        labelType: NavigationRailLabelType.all,
        indicatorColor: p.primary,
        minWidth: 84,
        selectedIconTheme: IconThemeData(color: p.primaryForeground),
        unselectedIconTheme: IconThemeData(color: p.mutedForeground),
        selectedLabelTextStyle: PumpTextStyles.label(p.primary),
        unselectedLabelTextStyle: PumpTextStyles.label(p.mutedForeground),
        onDestinationSelected: (i) => context.go(navSet.items[i].route),
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: PumpSpacing.lg),
          child: InkWell(
            onTap: () => context.go(navSet.homeRoute),
            borderRadius: BorderRadius.circular(PumpRadius.pill),
            child: Padding(
              padding: const EdgeInsets.all(PumpSpacing.sm),
              child: Icon(Icons.fitness_center, color: p.primary, size: 24),
            ),
          ),
        ),
        destinations: [
          for (final item in navSet.items)
            NavigationRailDestination(
              icon: Icon(item.icon),
              label: Text(item.label.toUpperCase()),
            ),
        ],
      ),
    );
  }
}
