import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/features/providers/schedule_screen_provider.dart';
import 'package:pump_gym/theme/pump_theme.dart';
import 'package:pump_gym/theme/theme_provider.dart';

class ExpectedGainsView extends ConsumerWidget {
  const ExpectedGainsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final metrics = ref.watch(expectedGainMetricsProvider);
    final distribution = ref.watch(volumeDistributionProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HYPERTROPHY BREAKDOWN'.tr(),
              style: PumpTextStyles.label(p.foreground)),
          const SizedBox(height: 14),
          for (var i = 0; i < metrics.length; i += 2) ...[
            if (i > 0) const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: _GainMetric(
                    value: metrics[i].value, label: metrics[i].label),
              ),
              const SizedBox(width: 10),
              if (i + 1 < metrics.length)
                Expanded(
                  child: _GainMetric(
                      value: metrics[i + 1].value, label: metrics[i + 1].label),
                ),
            ]),
          ],
          const SizedBox(height: 14),
          Text('VOLUME DISTRIBUTION'.tr(),
              style: PumpTextStyles.label(p.foreground)),
          const SizedBox(height: 12),
          for (final item in distribution)
            _VolumeDistributionRow(
              label: item.group,
              value: item.value,
              percent: item.percent,
            ),
        ],
      ),
    );
  }
}

class _GainMetric extends ConsumerWidget {
  final String value;
  final String label;
  const _GainMetric({required this.value, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.secondary,
        border: Border.all(color: p.border.withValues(alpha: .55)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value,
            style: PumpTextStyles.bodyLg(p.primary)
                .copyWith(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label.tr(), style: PumpTextStyles.label(p.mutedForeground)),
      ]),
    );
  }
}

class _VolumeDistributionRow extends ConsumerWidget {
  final String label;
  final double value;
  final String percent;
  const _VolumeDistributionRow({
    required this.label,
    required this.value,
    required this.percent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        SizedBox(
          width: 74,
          child: Text(label.tr().toUpperCase(),
              style: PumpTextStyles.label(p.mutedForeground)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(PumpRadius.pill),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 7,
              backgroundColor: p.secondary,
              valueColor: AlwaysStoppedAnimation(p.primary),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 26,
          child: Text(percent,
              textAlign: TextAlign.end,
              style: PumpTextStyles.label(p.foreground)),
        ),
      ]),
    );
  }
}

class ProtocolLibraryView extends ConsumerWidget {
  final ValueChanged<WorkoutProtocol> onInspect;
  const ProtocolLibraryView({super.key, required this.onInspect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protocols = ref.watch(workoutProtocolsProvider);
    return Column(
      children: protocols
          .map((protocol) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ProtocolLibraryCard(
                  protocol: protocol,
                  onInspect: () => onInspect(protocol),
                ),
              ))
          .toList(),
    );
  }
}

class ProtocolLibraryCard extends ConsumerWidget {
  final WorkoutProtocol protocol;
  final VoidCallback onInspect;
  const ProtocolLibraryCard({
    super.key,
    required this.protocol,
    required this.onInspect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _ProtocolArtwork(title: protocol.title, color: p.primary),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: Text(protocol.title.tr(),
                style: PumpTextStyles.bodyMd(p.foreground)
                    .copyWith(fontWeight: FontWeight.w700)),
          ),
          _PriceBadge(price: protocol.price),
        ]),
        const SizedBox(height: 6),
        Text(
          '{duration} · {difficulty} · {gain} EXPECTED · COACH {coach}'.tr(
            namedArgs: {
              'duration': protocol.duration.tr().toUpperCase(),
              'difficulty': protocol.difficulty.tr().toUpperCase(),
              'gain': protocol.expectedGain.tr().toUpperCase(),
              'coach': protocol.coach.toUpperCase(),
            },
          ),
          style: PumpTextStyles.label(p.mutedForeground)
              .copyWith(fontSize: 8, letterSpacing: .7),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onInspect,
            icon: const Icon(Icons.visibility_outlined, size: 13),
            label: Text('INSPECT PROTOCOL'.tr()),
            style: OutlinedButton.styleFrom(
              foregroundColor: p.foreground,
              side: BorderSide(color: p.border),
              minimumSize: const Size.fromHeight(34),
              textStyle: PumpTextStyles.label(p.foreground)
                  .copyWith(fontSize: 8, letterSpacing: .7),
              padding: const EdgeInsets.symmetric(vertical: 6),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Center(
          child: Text('PLANS ARE ASSIGNED BY YOUR COACH / ADMIN'.tr(),
              style: PumpTextStyles.label(p.mutedForeground)
                  .copyWith(fontSize: 7, letterSpacing: .7)),
        ),
      ]),
    );
  }
}

class ProtocolDetailSheet extends ConsumerWidget {
  final WorkoutProtocol protocol;
  const ProtocolDetailSheet({super.key, required this.protocol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: p.surface,
          border: Border.all(color: p.border),
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(protocol.title.tr().toUpperCase(),
                    style: PumpTextStyles.displayLg(p.foreground)),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close, color: p.mutedForeground, size: 18),
              ),
            ]),
            _ProtocolArtwork(
                title: protocol.title, color: p.primary, height: 78),
            const SizedBox(height: 8),
            _DetailGrid(items: [
              ('COACH', protocol.coach),
              ('CATEGORY', protocol.category.tr()),
              ('DIFFICULTY', protocol.difficulty.tr()),
              ('PRICE', protocol.price),
              ('EXPECTED GAIN', protocol.expectedGain.tr()),
              (
                'ENROLLED',
                '{count} athletes'.tr(namedArgs: {
                  'count': '${protocol.enrolledAthletes}',
                })
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                  child: _DetailStat(
                      value: '${protocol.trainingDays}',
                      label: 'TRAINING DAYS')),
              const SizedBox(width: 6),
              Expanded(
                  child: _DetailStat(
                      value: '${protocol.stations}', label: 'STATIONS')),
              const SizedBox(width: 6),
              Expanded(
                  child: _DetailStat(
                      value: '${protocol.totalSets}', label: 'TOTAL SETS')),
            ]),
            const SizedBox(height: 12),
            Text('COMPLETION RATE'.tr(),
                style: PumpTextStyles.label(p.mutedForeground)),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(PumpRadius.pill),
              child: LinearProgressIndicator(
                value: protocol.averageCompletion,
                minHeight: 7,
                backgroundColor: p.secondary,
                valueColor: AlwaysStoppedAnimation(p.primary),
              ),
            ),
            const SizedBox(height: 4),
            Row(children: [
              Expanded(
                child: Text('AVG ATHLETE COMPLETION'.tr(),
                    style: PumpTextStyles.label(p.mutedForeground)
                        .copyWith(fontSize: 8)),
              ),
              Text('${(protocol.averageCompletion * 100).round()}%',
                  style: PumpTextStyles.label(p.primary)),
            ]),
            const SizedBox(height: 12),
            Text('SAMPLE DAY 1 — PUSH DAY'.tr(),
                style: PumpTextStyles.label(p.foreground)),
            const SizedBox(height: 6),
            for (final exercise in protocol.sampleExercises)
              _SampleExerciseRow(exercise: exercise),
          ]),
        ),
      ),
    );
  }
}

class _ProtocolArtwork extends StatelessWidget {
  final String title;
  final Color color;
  final double height;
  const _ProtocolArtwork({
    required this.title,
    required this.color,
    this.height = 68,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: LinearGradient(
          colors: [color.withValues(alpha: .42), const Color(0xff11120e)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(children: [
        Positioned(
            right: 18,
            bottom: -22,
            child: Icon(Icons.fitness_center,
                size: height + 44, color: color.withValues(alpha: .2))),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(title.tr().toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: PumpTextStyles.label(Colors.white)
                    .copyWith(fontSize: 10, letterSpacing: 1.1)),
          ),
        ),
      ]),
    );
  }
}

class _PriceBadge extends ConsumerWidget {
  final String price;
  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: p.primary.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(PumpRadius.pill),
      ),
      child: Text(price,
          style: PumpTextStyles.label(p.primary).copyWith(fontSize: 8)),
    );
  }
}

class _DetailGrid extends ConsumerWidget {
  final List<(String, String)> items;
  const _DetailGrid({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 2.7,
      ),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: p.secondary,
          border: Border.all(color: p.border.withValues(alpha: .6)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(items[index].$1.tr(),
              style: PumpTextStyles.label(p.mutedForeground)
                  .copyWith(fontSize: 7)),
          const SizedBox(height: 3),
          Text(items[index].$2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PumpTextStyles.bodySm(p.foreground)
                  .copyWith(fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

class _DetailStat extends ConsumerWidget {
  final String value;
  final String label;
  const _DetailStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
      decoration: BoxDecoration(
        color: p.secondary,
        border: Border.all(color: p.border.withValues(alpha: .6)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: [
        Text(value,
            style: PumpTextStyles.bodyMd(p.primary)
                .copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label.tr(),
            textAlign: TextAlign.center,
            style:
                PumpTextStyles.label(p.mutedForeground).copyWith(fontSize: 7)),
      ]),
    );
  }
}

class _SampleExerciseRow extends ConsumerWidget {
  final ProtocolSampleExercise exercise;
  const _SampleExerciseRow({required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: p.secondary,
        borderRadius: BorderRadius.circular(PumpRadius.pill),
      ),
      child: Row(children: [
        Expanded(
          child: Text(exercise.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PumpTextStyles.bodySm(p.mutedForeground)
                  .copyWith(fontSize: 9)),
        ),
        const SizedBox(width: 8),
        Text(exercise.prescription,
            style: PumpTextStyles.label(p.mutedForeground)
                .copyWith(fontSize: 7, letterSpacing: .3)),
      ]),
    );
  }
}
