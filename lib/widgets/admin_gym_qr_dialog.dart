import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/dummy_data/admin_walk_in_dummy_data.dart';
import 'package:pump_gym/theme/theme_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future<void> showAdminGymQrDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _AdminGymQrDialog(),
  );
}

class _AdminGymQrDialog extends ConsumerWidget {
  const _AdminGymQrDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Dialog(
      backgroundColor: p.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: p.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'GYM ENTRANCE QR'.tr(),
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
            Container(
              width: 264,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  QrImageView(
                    data: adminGymNameDummyData,
                    size: 224,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '{gym} · {entrance}'.tr(namedArgs: {
                      'gym': adminGymNameDummyData,
                      'entrance': adminGymEntranceDummyData,
                    }),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 10,
                      letterSpacing: .6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Display this at the front desk — athletes scan it with the app to check themselves in.'
                  .tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: p.mutedForeground, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
