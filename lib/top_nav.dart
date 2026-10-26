import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/constants/app_routes.dart';
import 'package:pump_gym/nav_icons.dart';
import 'package:pump_gym/theme/pump_theme.dart';
import 'package:pump_gym/theme/theme_options.dart';
import 'package:pump_gym/theme/theme_provider.dart';
import 'package:pump_gym/theme/pump_colors.dart';
import 'package:pump_gym/widgets/top_bar.dart' show IconPill;

/// Desktop navigation (expanded layout, width >= 1024).
///
/// This bar REPLACES the per-screen TopBar / AdminTopBar on wide screens. It
/// carries the same things: back button (when the screen was pushed), logo,
/// language pill, notifications bell, and the profile avatar (athlete) or a
/// logout button (admin). Screens hide their own top bar via
/// `showsDesktopTopNav(context)` from pump_shell.dart.
class PumpTopNav extends ConsumerWidget {
  final PumpNavSet navSet;
  const PumpTopNav({super.key, required this.navSet});

  static const double height = 64;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final location = GoRouterState.of(context).matchedLocation;
    final canPop = context.canPop();
    final selectedIndex = navSet.indexOf(location);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: p.surface,
        border: Border(bottom: BorderSide(color: p.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: pumpContentMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: PumpSpacing.lg),
            child: Row(
              children: [
                if (canPop) ...[
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const IconPill(icon: Icons.arrow_back),
                  ),
                  const SizedBox(width: PumpSpacing.sm),
                ],
                if (navSet.isAdmin)
                  const _AdminThemeMenu()
                else
                  _Logo(onTap: () => context.go(navSet.homeRoute)),
                if (navSet.isAdmin) ...[
                  const SizedBox(width: PumpSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PumpSpacing.md,
                      vertical: PumpSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: p.secondary,
                      borderRadius: BorderRadius.circular(PumpRadius.pill),
                    ),
                    child:
                        Text('ADMIN', style: PumpTextStyles.label(p.primary)),
                  ),
                ],
                const SizedBox(width: PumpSpacing.xxxl),
                for (int i = 0; i < navSet.items.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: PumpSpacing.xs),
                    child: _NavLink(
                      item: navSet.items[i],
                      selected: i == selectedIndex,
                    ),
                  ),
                const Spacer(),
                PopupMenuButton<Locale>(
                  tooltip: 'Change language'.tr(),
                  onSelected: (locale) => context.setLocale(locale),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: Locale('en'), child: Text('English')),
                    PopupMenuItem(value: Locale('ar'), child: Text('العربية')),
                  ],
                  child: IconPill(
                    child: Text(
                      context.locale.languageCode.toUpperCase(),
                      style: PumpTextStyles.bodySm(p.foreground),
                    ),
                  ),
                ),
                const SizedBox(width: PumpSpacing.sm),
                const _BellWithBadge(),
                const SizedBox(width: PumpSpacing.md),
                if (navSet.isAdmin)
                  // Same behavior as AdminTopBar's logout button.
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.auth),
                    child: const IconPill(icon: Icons.logout),
                  )
                else
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.profile),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: p.primary,
                      child: Icon(Icons.person, color: p.primaryForeground),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminThemeMenu extends ConsumerWidget {
  const _AdminThemeMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeId = ref.watch(themeProvider);
    final p = ref.watch(pumpPaletteProvider);

    return PopupMenuButton<PumpThemeId>(
      tooltip: 'Change app theme'.tr(),
      onSelected: (theme) {
        ref.read(themeProvider.notifier).setTheme(theme);
      },
      itemBuilder: (context) => [
        for (final option in themeOptions)
          PopupMenuItem<PumpThemeId>(
            value: option.themeId,
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: option.swatch),
                  ),
                ),
                const SizedBox(width: PumpSpacing.sm),
                Expanded(child: Text(option.name.tr())),
                if (option.themeId == themeId)
                  Icon(Icons.check, color: p.primary, size: 18),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(Icons.fitness_center, color: p.primary, size: 22),
            const SizedBox(width: PumpSpacing.sm),
            Text('PUMP', style: PumpTextStyles.displayLg(p.foreground)),
          ],
        ),
      ),
    );
  }
}

class _Logo extends ConsumerWidget {
  final VoidCallback onTap;
  const _Logo({required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(PumpRadius.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(Icons.fitness_center, color: p.primary, size: 22),
            const SizedBox(width: PumpSpacing.sm),
            Text('PUMP', style: PumpTextStyles.displayLg(p.foreground)),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends ConsumerWidget {
  final PumpNavItem item;
  final bool selected;
  const _NavLink({required this.item, required this.selected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final fg = selected ? p.primaryForeground : p.mutedForeground;

    return Material(
      color: selected ? p.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(PumpRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(PumpRadius.pill),
        onTap: () => context.go(item.route),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PumpSpacing.lg,
            vertical: PumpSpacing.sm,
          ),
          child:
              Text(item.label.toUpperCase(), style: PumpTextStyles.label(fg)),
        ),
      ),
    );
  }
}

class _BellWithBadge extends ConsumerWidget {
  const _BellWithBadge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const IconPill(icon: Icons.notifications_none),
        Positioned(
          right: -2,
          top: -2,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
            // TODO: replace the hardcoded count with real notification state.
            child: Text('6', style: PumpTextStyles.label(p.primaryForeground)),
          ),
        ),
      ],
    );
  }
}
