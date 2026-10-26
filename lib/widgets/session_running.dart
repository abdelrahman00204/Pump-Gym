import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/constants/app_routes.dart';
import 'package:pump_gym/theme/pump_theme.dart';
import 'package:pump_gym/theme/theme_provider.dart';

class SessionRunningBar extends ConsumerWidget {
  final VoidCallback? onTap;
  final String? elapsed;

  const SessionRunningBar({super.key, this.onTap, this.elapsed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return GestureDetector(
      onTap: onTap ?? () => context.go(AppRoutes.session),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: p.primary,
          borderRadius: BorderRadius.circular(PumpRadius.pill),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  color: p.primaryForeground, shape: BoxShape.circle),
            ),
            const SizedBox(width: PumpSpacing.sm),
            Expanded(
              child: Text(
                elapsed == null
                    ? 'SESSION RUNNING — TAP TO RETURN'.tr()
                    : 'SESSION RUNNING — {elapsed}'.tr(
                        namedArgs: {'elapsed': elapsed!},
                      ),
                style: TextStyle(
                  color: p.primaryForeground,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
