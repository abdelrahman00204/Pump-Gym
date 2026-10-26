import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/theme/pump_colors.dart';
import 'package:pump_gym/theme/pump_theme.dart';
import 'package:pump_gym/theme/theme_provider.dart';
import 'package:pump_gym/dummy_data/workout_history_dummy_data.dart';
import 'package:pump_gym/widgets/session_running.dart';
import 'package:pump_gym/widgets/top_bar.dart';
import 'package:pump_gym/widgets/workout_report_pdf.dart';
import 'package:pump_gym/wide_layout.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return AthleteShell(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              if (!showsDesktopTopNav(context))
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTopBarDelegate(
                    child: Container(
                      color: p.background,
                      padding: const EdgeInsets.symmetric(
                        horizontal: PumpSpacing.lg,
                        vertical: 8,
                      ),
                      child: TopBar(
                        canPop: context.canPop(),
                        onBack: () => context.pop(),
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PumpSpacing.lg,
                  vertical: PumpSpacing.md,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(height: PumpSpacing.sm),
                      const _StatsGrid(),
                      const SizedBox(
                        height: PumpSpacing.lg - PumpSpacing.sm,
                      ),
                      const _IntensityMatrixCard(),
                      const SizedBox(height: PumpSpacing.lg),
                      const _DownloadReportButton(),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const PumpFloatingBar(child: SessionRunningBar()),
        ],
      ),
    );
  }
}

class _StickyTopBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTopBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(covariant _StickyTopBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}

// ---------------------------------------------------------------------------
// Intensity data
// ---------------------------------------------------------------------------
Color colorFor(WorkoutIntensity intensity, PumpPalette palette) {
  switch (intensity) {
    case WorkoutIntensity.peak:
      return palette.primary;
    case WorkoutIntensity.high:
      return palette.primary.withValues(alpha: 0.65);
    case WorkoutIntensity.moderate:
      return palette.primary.withValues(alpha: 0.35);
    case WorkoutIntensity.rest:
      return palette.secondary;
  }
}

Color textColorFor(WorkoutIntensity intensity, PumpPalette palette) {
  switch (intensity) {
    case WorkoutIntensity.peak:
    case WorkoutIntensity.high:
    case WorkoutIntensity.moderate:
      return palette.primaryForeground;
    case WorkoutIntensity.rest:
      return palette.mutedForeground;
  }
}

// ---------------------------------------------------------------------------
// Stats grid (2 rows x 3 cols)
// ---------------------------------------------------------------------------
class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return PumpCardGrid(
      compact: 3,
      medium: 3,
      expanded: 6,
      children: [
        for (final stat in workoutHistoryStatsDummyData)
          _StatCard(value: stat.value, label: stat.label),
      ],
    );
  }
}

class _StatCard extends ConsumerWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      height: 110,
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(value,
              style: PumpTextStyles.bodyLg(p.primary)
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 26)),
          const SizedBox(height: 4),
          Text(label.tr(),
              style: PumpTextStyles.label(p.mutedForeground)
                  .copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.3)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 30-day intensity matrix card
// ---------------------------------------------------------------------------
class _IntensityMatrixCard extends ConsumerWidget {
  const _IntensityMatrixCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

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
          Text('30-DAY INTENSITY MATRIX'.tr(),
              style: PumpTextStyles.bodyMd(p.foreground)
                  .copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: PumpSpacing.md),
          Wrap(
            spacing: PumpSpacing.sm,
            runSpacing: PumpSpacing.sm,
            children: List.generate(30, (i) {
              final day = i + 1;
              final intensity =
                  workoutHistoryMatrixIntensitiesDummyData[day - 1];
              return Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorFor(intensity, p),
                  shape: BoxShape.circle,
                ),
                child: Text('$day',
                    style: TextStyle(
                        color: textColorFor(intensity, p),
                        fontSize: 13,
                        fontWeight: intensity == WorkoutIntensity.peak
                            ? FontWeight.bold
                            : FontWeight.w600)),
              );
            }),
          ),
          const SizedBox(height: PumpSpacing.md),
          Wrap(
            spacing: PumpSpacing.sm,
            runSpacing: PumpSpacing.sm,
            children: [
              _LegendPill(
                  label: 'Peak',
                  color: p.primary,
                  textColor: p.primaryForeground),
              _LegendPill(
                  label: 'High',
                  color: p.primary.withValues(alpha: 0.65),
                  textColor: p.primaryForeground),
              _LegendPill(
                  label: 'Moderate',
                  color: p.primary.withValues(alpha: 0.35),
                  textColor: p.primaryForeground),
              _LegendPill(
                  label: 'Rest',
                  color: Colors.transparent,
                  textColor: p.mutedForeground,
                  outlined: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendPill extends ConsumerWidget {
  final String label;
  final Color color;
  final Color textColor;
  final bool outlined;
  const _LegendPill({
    required this.label,
    required this.color,
    required this.textColor,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        border: outlined ? Border.all(color: p.border) : null,
        borderRadius: BorderRadius.circular(PumpRadius.pill),
      ),
      child: Text(label.tr().toUpperCase(),
          style: TextStyle(
              color: textColor, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}

// ---------------------------------------------------------------------------
// Download report button
// ---------------------------------------------------------------------------
class _DownloadReportButton extends ConsumerWidget {
  const _DownloadReportButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          try {
            await WorkoutReportPdf.download();
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('PDF saved to Downloads'.tr())),
            );
          } catch (error) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Unable to download PDF: {error}'.tr(
                    namedArgs: {'error': '$error'},
                  ),
                ),
              ),
            );
          }
        },
        icon: Icon(Icons.download, color: p.primaryForeground),
        label: Text('DOWNLOAD PDF'.tr(),
            style: PumpTextStyles.label(p.primaryForeground)
                .copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.3)),
        style: ElevatedButton.styleFrom(
          backgroundColor: p.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(PumpRadius.pill)),
        ),
      ),
    );
  }
}
