import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pump_gym/dummy_data/session_dummy_data.dart';
import 'package:pump_gym/theme/pump_colors.dart';
import 'package:pump_gym/theme/pump_theme.dart';

class SessionTimer extends StatelessWidget {
  final String elapsed;
  final PumpPalette palette;

  const SessionTimer({
    super.key,
    required this.elapsed,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Container(
      padding: const EdgeInsets.all(PumpSpacing.md),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      child: Column(
        children: [
          Text(
            elapsed,
            style: PumpTextStyles.display2xl(p.foreground).copyWith(
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: PumpSpacing.sm),
          Row(
            children: [
              for (var i = 0; i < sessionTimerStatsDummyData.length; i++) ...[
                _StatTile(
                  value: sessionTimerStatsDummyData[i].$1,
                  label: sessionTimerStatsDummyData[i].$2,
                  palette: p,
                ),
                if (i < sessionTimerStatsDummyData.length - 1)
                  const SizedBox(width: PumpSpacing.sm),
              ],
            ],
          ),
          const SizedBox(height: PumpSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _QuickAdjust(label: '-1M', palette: p),
              const SizedBox(width: PumpSpacing.sm),
              _QuickAdjust(label: '+1M', palette: p),
              const SizedBox(width: PumpSpacing.sm),
              _QuickAdjust(label: '+5M', palette: p),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final PumpPalette palette;

  const _StatTile({
    required this.value,
    required this.label,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: palette.secondary,
          borderRadius: BorderRadius.circular(PumpRadius.card),
        ),
        child: Column(
          children: [
            Text(value, style: PumpTextStyles.bodyMd(palette.primary)),
            const SizedBox(height: 3),
            Text(label.tr(),
                style: PumpTextStyles.label(palette.mutedForeground)),
          ],
        ),
      ),
    );
  }
}

class _QuickAdjust extends StatelessWidget {
  final String label;
  final PumpPalette palette;

  const _QuickAdjust({required this.label, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(PumpRadius.pill),
      ),
      child: Text(label.tr(),
          style: PumpTextStyles.label(palette.mutedForeground)),
    );
  }
}
