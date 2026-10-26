import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/admin_shell.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/constants/app_routes.dart';
import 'package:pump_gym/features/providers/admin_walk_in_provider.dart';
import 'package:pump_gym/theme/pump_theme.dart';
import 'package:pump_gym/theme/theme_provider.dart';
import 'package:pump_gym/widgets/admin_add_visitor_dialog.dart';
import 'package:pump_gym/widgets/admin_gym_qr_dialog.dart';
import 'package:pump_gym/widgets/admin_top_bar.dart';
import 'package:pump_gym/widgets/admin_walk_in_check_in_dialog.dart';
import 'package:pump_gym/widgets/admin_walk_in_presence_tile.dart';
import 'package:pump_gym/wide_layout.dart';

class AdminWalkInScreen extends ConsumerWidget {
  const AdminWalkInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final records = ref.watch(adminWalkInRecordsProvider);
    final inside = records.where((record) => record.checkedOutAt == null);
    return AdminShell(
      body: Column(
        children: [
          if (!showsDesktopTopNav(context)) const AdminTopBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              children: [
                Text(
                  'ADMIN HQ CONSOLE'.tr(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 28),
                PumpColumns(
                  main: [
                    PumpCardGrid(
                      compact: 2,
                      medium: 2,
                      expanded: 3,
                      spacing: PumpSpacing.md,
                      children: [
                        _ActionButton(
                          icon: Icons.qr_code_2,
                          text: 'SHOW GYM QR'.tr(),
                          filled: true,
                          onPressed: () => showAdminGymQrDialog(context),
                        ),
                        _ActionButton(
                          icon: Icons.login,
                          text: 'CHECK IN'.tr(),
                          filled: true,
                          onPressed: () =>
                              showAdminWalkInCheckInDialog(context, ref),
                        ),
                        _ActionButton(
                          icon: Icons.person_add_alt_1,
                          text: 'ADD VISITOR'.tr(),
                          onPressed: () =>
                              showAdminAddVisitorDialog(context, ref),
                        ),
                        _ActionButton(
                          icon: Icons.history,
                          text: 'WALK-IN HISTORY'.tr(),
                          onPressed: () => context.go(AppRoutes.walkInHistory),
                        ),
                      ],
                    ),
                  ],
                  side: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                      decoration: BoxDecoration(
                        color: p.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: p.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CURRENTLY IN THE GYM — {count}'.tr(
                              namedArgs: {'count': '${inside.length}'},
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              letterSpacing: 1.5,
                            ),
                          ),
                          if (inside.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 22),
                              child: Center(
                                child: Text(
                                  'No one is currently checked in.'.tr(),
                                  style: TextStyle(color: p.mutedForeground),
                                ),
                              ),
                            )
                          else
                            for (final record in inside)
                              AdminWalkInPresenceTile(
                                record: record,
                                onCheckOut: () => ref
                                    .read(
                                      adminWalkInRecordsProvider.notifier,
                                    )
                                    .checkOut(record.id),
                              ),
                        ],
                      ),
                    ),
                  ],
                  spacing: PumpSpacing.lg,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool filled;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).colorScheme;
    return SizedBox(
      height: 64,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text, textAlign: TextAlign.center),
        style: ElevatedButton.styleFrom(
          backgroundColor: filled ? p.primary : Colors.transparent,
          foregroundColor: filled ? p.onPrimary : p.onSurface,
          side: filled ? null : BorderSide(color: p.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
    );
  }
}
