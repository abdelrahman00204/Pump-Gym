import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/dummy_data/admin_athletes_dummy_data.dart';
import 'package:pump_gym/dummy_data/admin_walk_in_dummy_data.dart';
import 'package:pump_gym/features/providers/admin_walk_in_provider.dart';
import 'package:pump_gym/theme/theme_provider.dart';
import 'package:pump_gym/widgets/admin_walk_in_check_in_tile.dart';
import 'package:pump_gym/widgets/admin_walk_in_search_bar.dart';

Future<void> showAdminWalkInCheckInDialog(
  BuildContext context,
  WidgetRef ref,
) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _AdminWalkInCheckInDialog(),
  );
}

class _AdminWalkInCheckInDialog extends ConsumerStatefulWidget {
  const _AdminWalkInCheckInDialog();

  @override
  ConsumerState<_AdminWalkInCheckInDialog> createState() =>
      _AdminWalkInCheckInDialogState();
}

class _AdminWalkInCheckInDialogState
    extends ConsumerState<_AdminWalkInCheckInDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(pumpPaletteProvider);
    final records = ref.watch(adminWalkInRecordsProvider);
    final athletes = adminAthletesDummyData.where((athlete) {
      final username = adminAthleteUsernameDummyData(athlete);
      return athlete.name.toLowerCase().contains(_query.toLowerCase()) ||
          username.toLowerCase().contains(_query.toLowerCase());
    }).toList();
    return Dialog(
      backgroundColor: p.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: p.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'CHECK IN A MEMBER'.tr(),
                      style: TextStyle(
                        color: p.foreground,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close'.tr(),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Text(
                "Simulate scanning a registered athlete's QR code to check them into the gym."
                    .tr(),
                style: TextStyle(color: p.mutedForeground, fontSize: 12),
              ),
              const SizedBox(height: 12),
              AdminWalkInSearchBar(
                onChanged: (value) => setState(() => _query = value.trim()),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: athletes.isEmpty
                    ? Center(
                        child: Text(
                          'No athletes match your search.'.tr(),
                          style: TextStyle(color: p.mutedForeground),
                        ),
                      )
                    : ListView.builder(
                        itemCount: athletes.length,
                        itemBuilder: (context, index) {
                          final athlete = athletes[index];
                          final username =
                              adminAthleteUsernameDummyData(athlete);
                          final alreadyInside = records.any(
                            (record) =>
                                record.name == athlete.name &&
                                !record.oneTimeVisitor &&
                                record.checkedOutAt == null,
                          );
                          return AdminWalkInCheckInTile(
                            name: athlete.name,
                            username: username,
                            checkedIn: alreadyInside,
                            onCheckIn: () {
                              ref
                                  .read(adminWalkInRecordsProvider.notifier)
                                  .checkInMember(
                                    id: 'athlete-${athlete.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}',
                                    name: athlete.name,
                                    username: username,
                                  );
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
