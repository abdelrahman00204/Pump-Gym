import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/nav_icons.dart';
import 'package:pump_gym/theme/theme_provider.dart';

/// Phone navigation (compact layout). Icon-only, destinations come from
/// [navSet] (nav_items.dart), so it always matches the side and top nav.
/// Defaults to the athlete set, so existing `const BottomNav()` calls work.
class BottomNav extends ConsumerWidget {
  final PumpNavSet navSet;
  const BottomNav({super.key, this.navSet = athleteNavSet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = navSet.indexOf(location);

    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        border: Border(top: BorderSide(color: p.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < navSet.items.length; i++)
            IconButton(
              tooltip: navSet.items[i].label,
              icon: Icon(
                navSet.items[i].icon,
                color: i == selectedIndex ? p.primary : p.mutedForeground,
              ),
              onPressed: () => context.go(navSet.items[i].route),
            ),
        ],
      ),
    );
  }
}
