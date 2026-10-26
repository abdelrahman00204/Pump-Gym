import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/constants/app_routes.dart';
import 'package:pump_gym/dummy_data/notification_dummy_data.dart';
import 'package:pump_gym/theme/pump_theme.dart';
import 'package:pump_gym/theme/theme_provider.dart';

class TopBar extends ConsumerWidget {
  // CHANGED: Added optional properties to support a back button toggle for child screens like Profile.
  final bool canPop;
  final VoidCallback? onBack;

  const TopBar({super.key, this.canPop = false, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return Row(
      children: [
        GestureDetector(
          onTap: () => context.push(AppRoutes.profile),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: p.primary,
            child: Icon(Icons.person, color: p.primaryForeground),
          ),
        ),
        const SizedBox(width: PumpSpacing.sm),

        // CHANGED: Wrapped the branding element in a GestureDetector
        // to handle popping the navigation stack if canPop is true.
        GestureDetector(
          onTap: canPop ? (onBack ?? () => context.pop()) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: p.surface,
              border: Border.all(color: p.border),
              borderRadius: BorderRadius.circular(PumpRadius.pill),
            ),
            child: Row(
              children: [
                // CHANGED: Dynamically switch from fitness_center to arrow_back when canPop is true.
                Icon(canPop ? Icons.arrow_back : Icons.fitness_center,
                    color: p.primary, size: 16),
                const SizedBox(width: 6),
                Text('PUMP',
                    style: PumpTextStyles.bodyMd(p.foreground)
                        .copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const Spacer(),

        const SizedBox(width: PumpSpacing.sm),
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
        Stack(
          clipBehavior: Clip.none,
          children: [
            const IconPill(icon: Icons.notifications_none),
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration:
                    BoxDecoration(color: p.primary, shape: BoxShape.circle),
                child: Text(
                  '$unreadNotificationCountDummyData',
                  style: PumpTextStyles.label(p.primaryForeground),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class IconPill extends ConsumerWidget {
  final IconData? icon;
  final Widget? child;
  const IconPill({super.key, this.icon, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: child ?? Icon(icon, color: p.foreground, size: 18),
    );
  }
}
