import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/theme/theme_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AdminWalkInCheckInTile extends ConsumerWidget {
  final String name;
  final String username;
  final bool checkedIn;
  final VoidCallback onCheckIn;

  const AdminWalkInCheckInTile({
    super.key,
    required this.name,
    required this.username,
    required this.checkedIn,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: p.secondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(2),
            color: Colors.white,
            child: QrImageView(
              data: username.isEmpty ? name : username,
              backgroundColor: Colors.white,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                if (username.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    username,
                    style: TextStyle(
                      color: p.mutedForeground,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 6),
          FilledButton.icon(
            onPressed: checkedIn ? null : onCheckIn,
            icon: Icon(
              checkedIn ? Icons.check : Icons.bolt,
              size: 15,
            ),
            label: Text((checkedIn ? 'INSIDE' : 'CHECK IN').tr()),
            style: FilledButton.styleFrom(
              backgroundColor: p.primary,
              foregroundColor: p.primaryForeground,
              disabledBackgroundColor: p.primary.withValues(alpha: .18),
              disabledForegroundColor: p.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              textStyle: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
