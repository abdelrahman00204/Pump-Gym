import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/dummy_data/admin_walk_in_dummy_data.dart';
import 'package:pump_gym/theme/theme_provider.dart';

class AdminWalkInPresenceTile extends ConsumerWidget {
  final AdminWalkInRecord record;
  final VoidCallback onCheckOut;

  const AdminWalkInPresenceTile({
    super.key,
    required this.record,
    required this.onCheckOut,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: p.secondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'CHECKED IN AT {time} · {source} · {kind}'.tr(
                    namedArgs: {
                      'time': _time(record.checkedInAt),
                      'source': record.source.tr(),
                      'kind': record.oneTimeVisitor
                          ? 'ONE-TIME VISITOR'.tr()
                          : 'REGISTERED ATHLETE'.tr(),
                    },
                  ),
                  style: TextStyle(
                    color: p.mutedForeground,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .7,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: record.checkedOutAt == null ? onCheckOut : null,
            icon: const Icon(Icons.login, size: 14),
            label: Text(
              record.checkedOutAt == null
                  ? 'WORKOUT FINISHED'.tr()
                  : 'CHECKED OUT {time}'.tr(
                      namedArgs: {'time': _time(record.checkedOutAt!)},
                    ),
              textAlign: TextAlign.center,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: record.checkedOutAt == null
                  ? p.foreground
                  : p.mutedForeground,
              side: BorderSide(color: p.border),
              textStyle: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: .6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _time(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';
}
