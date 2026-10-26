import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pump_gym/theme/pump_colors.dart';
import 'package:pump_gym/theme/pump_theme.dart';

class RestTimer extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final PumpPalette palette;
  final ValueChanged<int> onAddTime;
  final VoidCallback onSkip;

  const RestTimer({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.palette,
    required this.onAddTime,
    required this.onSkip,
  });

  String get _formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final p = palette;
    final progress = (remainingSeconds / totalSeconds).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(PumpSpacing.lg),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.primary.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      child: Column(
        children: [
          Text(
            'REST TIMER — AUTO-STARTED AFTER SET'.tr(),
            style: PumpTextStyles.label(p.foreground),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PumpSpacing.lg),
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    strokeCap: StrokeCap.round,
                    backgroundColor: p.secondary,
                    valueColor: AlwaysStoppedAnimation(p.primary),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formattedTime,
                      style: PumpTextStyles.bodyLg(p.foreground)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'RESTING'.tr(),
                      style: PumpTextStyles.label(p.mutedForeground),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: PumpSpacing.md),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: PumpSpacing.sm,
            runSpacing: PumpSpacing.sm,
            children: [
              _RestTimerButton(
                label: '+15S',
                palette: p,
                onPressed: () => onAddTime(15),
              ),
              _RestTimerButton(
                label: '+30S',
                palette: p,
                onPressed: () => onAddTime(30),
              ),
              _RestTimerButton(
                label: 'SKIP REST',
                palette: p,
                isPrimary: true,
                onPressed: onSkip,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RestTimerButton extends StatelessWidget {
  final String label;
  final PumpPalette palette;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _RestTimerButton({
    required this.label,
    required this.palette,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isPrimary ? p.primaryForeground : p.foreground,
        backgroundColor: isPrimary ? p.primary : Colors.transparent,
        side: BorderSide(color: isPrimary ? p.primary : p.border),
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: PumpSpacing.md),
        textStyle: PumpTextStyles.label(
          isPrimary ? p.primaryForeground : p.foreground,
        ),
        shape: const StadiumBorder(),
      ),
      child: Text(label.tr()),
    );
  }
}
