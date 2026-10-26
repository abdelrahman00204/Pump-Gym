import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/constants/app_routes.dart';
import 'package:pump_gym/theme/theme_provider.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    // CHANGED: Defined the navigation items as a list of records (IconData, RoutePath)
    // just like your R Burger implementation, omitting labels since PUMP uses icon-only nav.
    final items = [
      (Icons.home, AppRoutes.lobby),
      (Icons.calendar_today_outlined, AppRoutes.plans),
      (Icons.fitness_center, AppRoutes.catalog),
      (Icons.emoji_events_outlined, AppRoutes.community),
      (Icons.history, AppRoutes.history),
    ];

    // CHANGED: Fetch the current location from GoRouter to determine active state.
    final location = GoRouterState.of(context).matchedLocation;

    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        border: Border(top: BorderSide(color: p.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // CHANGED: Mapped over the items list to generate the IconButtons dynamically.
        children: items.map((item) {
          final isSelected = location == item.$2;

          return IconButton(
            // CHANGED: Dynamically apply the primary accent color if selected, otherwise muted[cite: 3].
            icon: Icon(
              item.$1,
              color: isSelected ? p.primary : p.mutedForeground,
            ),
            onPressed: () => context.go(item.$2),
          );
        }).toList(),
      ),
    );
  }
}
