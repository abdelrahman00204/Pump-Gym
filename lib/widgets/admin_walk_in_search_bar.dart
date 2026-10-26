import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/theme/theme_provider.dart';

class AdminWalkInSearchBar extends ConsumerWidget {
  final ValueChanged<String> onChanged;

  const AdminWalkInSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search by name or username...'.tr(),
        prefixIcon: Icon(Icons.search, color: p.mutedForeground),
        filled: true,
        fillColor: p.secondary,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: p.border),
        ),
      ),
    );
  }
}
