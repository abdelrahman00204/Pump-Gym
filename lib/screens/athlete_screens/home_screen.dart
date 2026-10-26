import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/theme/theme_provider.dart';
import 'package:pump_gym/features/providers/muscle_projection_provider.dart';
import 'package:pump_gym/dummy_data/home_dashboard_dummy_data.dart';
import 'package:pump_gym/widgets/qr_scan.dart';
import 'package:pump_gym/widgets/session_running.dart';
import 'package:pump_gym/widgets/top_bar.dart';
import 'package:pump_gym/wide_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/pump_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
                        vertical: PumpSpacing.md,
                      ),
                      child: const TopBar(),
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
                    const [
                      _HeroCard(),
                      SizedBox(height: PumpSpacing.xl),
                      PumpColumns(
                        main: [_ScheduleSection()],
                        side: [
                          _MuscleProjectionSection(),
                          _VolumeTrajectorySection(),
                        ],
                        spacing: PumpSpacing.xl,
                      ),
                      SizedBox(height: PumpSpacing.xxl),
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
  double get maxExtent => 64.0; // CHANGED from 72.0 to match child height

  @override
  double get minExtent => 64.0; // CHANGED from 72.0 to match child height

  @override
  bool shouldRebuild(covariant _StickyTopBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}

// ---------------------------------------------------------------------------
// Hero card
// ---------------------------------------------------------------------------
class _HeroCard extends ConsumerWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [p.secondary, p.background],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child:
                    Icon(Icons.sports_gymnastics, color: p.primary, size: 56),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: p.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(homeDashboardTierDummyData,
                style: PumpTextStyles.label(p.primary)),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(homeDashboardProgramDummyData,
                    style: PumpTextStyles.displayXl(p.foreground)
                        .copyWith(height: 1.1)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: p.secondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(homeDashboardPowerPointsDummyData,
                        style: PumpTextStyles.bodyLg(p.primary)
                            .copyWith(fontWeight: FontWeight.bold)),
                    Text('POWER PTS'.tr(),
                        style: PumpTextStyles.label(p.mutedForeground)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(homeDashboardCoachProgressDummyData.tr(),
              style: PumpTextStyles.bodySm(p.mutedForeground)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.circle, color: p.primary, size: 8),
              const SizedBox(width: 4),
              Text(
                  '{count} in gym'.tr(namedArgs: {
                    'count': '$homeDashboardGymOccupancyDummyData',
                  }),
                  style: PumpTextStyles.bodySm(p.primary)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Protocol Completion'.tr(),
                  style: PumpTextStyles.bodySm(p.mutedForeground)),
              const Spacer(),
              Text(
                  '${(homeDashboardProtocolCompletionDummyData * 100).round()}%',
                  style: PumpTextStyles.bodySm(p.foreground)
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          const _ProgressBar(value: homeDashboardProtocolCompletionDummyData),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showGymQrModal(
                  context,
                  userId: homeDashboardQrUserIdDummyData,
                  username: homeDashboardQrUsernameDummyData,
                  isAdmin: false,
                );
              },
              icon: Icon(Icons.play_arrow, color: p.primaryForeground),
              label: Text("Start Today's Workout".tr()),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.check_circle, color: p.primary, size: 14),
              const SizedBox(width: 6),
              Text('Gate verified — equipment unlocked'.tr(),
                  style: PumpTextStyles.bodySm(p.primary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends ConsumerWidget {
  final double value;
  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 8,
        backgroundColor: p.secondary,
        valueColor: AlwaysStoppedAnimation(p.primary),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scheduled routine
// ---------------------------------------------------------------------------
class _ScheduleSection extends ConsumerWidget {
  const _ScheduleSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text("Today's scheduled routine".tr(),
                  style: PumpTextStyles.bodyLg(p.foreground)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: p.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(homeDashboardWeekLabelDummyData.tr(),
                  style: PumpTextStyles.label(p.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final ex in homeExercisesDummyData) ...[
          _ExerciseCard(name: ex.name, detail: ex.detail, pin: ex.pin),
          const SizedBox(height: 10),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/plans'),
            icon: Icon(Icons.calendar_today, color: p.foreground, size: 16),
            label: Text('View full 30 days'.tr(),
                style: PumpTextStyles.bodyMd(p.foreground)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: p.border),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExerciseCard extends ConsumerWidget {
  final String name;
  final String detail;
  final String pin;
  const _ExerciseCard(
      {required this.name, required this.detail, required this.pin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: p.secondary, borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.fitness_center, color: p.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name.tr(),
                    style: PumpTextStyles.bodyMd(p.foreground)
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(detail.tr(),
                    style: PumpTextStyles.bodySm(p.mutedForeground)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
                color: p.secondary, borderRadius: BorderRadius.circular(8)),
            child: Text(pin.tr(),
                style: PumpTextStyles.bodySm(p.mutedForeground)
                    .copyWith(fontSize: 11)),
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, color: p.mutedForeground),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Muscle growth & hypertrophy projection
// ---------------------------------------------------------------------------
class _MuscleProjectionSection extends ConsumerWidget {
  const _MuscleProjectionSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final selectedGroup = ref.watch(selectedMuscleGroupProvider);

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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: muscleGroupsDummyData
                  .map((group) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: group,
                          selected: selectedGroup == group,
                          onTap: () => ref
                              .read(selectedMuscleGroupProvider.notifier)
                              .select(group),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          for (final m in musclesByGroupDummyData[selectedGroup]!) ...[
            _MuscleBar(name: m.name, value: m.value),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends ConsumerWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.onTap, this.selected = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? p.primary : p.surface,
          border: Border.all(color: selected ? p.primary : p.border),
          borderRadius: BorderRadius.circular(PumpRadius.pill),
        ),
        child: Text(label.tr().toUpperCase(),
            style: PumpTextStyles.label(
                selected ? p.primaryForeground : p.mutedForeground)),
      ),
    );
  }
}

class _MuscleBar extends ConsumerWidget {
  final String name;
  final double value;
  const _MuscleBar({required this.name, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(name.tr().toUpperCase(),
              style: PumpTextStyles.label(p.mutedForeground)),
        ),
        Expanded(child: _ProgressBar(value: value)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Volume & tonnage trajectory
// ---------------------------------------------------------------------------
class _VolumeTrajectorySection extends ConsumerWidget {
  const _VolumeTrajectorySection();

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
          Row(
            children: [
              Expanded(
                child: Text('Volume & tonnage trajectory'.tr(),
                    style: PumpTextStyles.bodyLg(p.foreground)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: p.primary,
                    borderRadius: BorderRadius.circular(PumpRadius.pill)),
                child: Text('Load ×1.0'.tr(),
                    style: PumpTextStyles.label(p.primaryForeground)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < 2; i++) ...[
                Expanded(
                  child: _VolumeCard(
                    label: homeVolumeWeeksDummyData[i].label,
                    value: homeVolumeWeeksDummyData[i].progress,
                    pct: homeVolumeWeeksDummyData[i].percentage,
                  ),
                ),
                if (i == 0) const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 2; i < homeVolumeWeeksDummyData.length; i++) ...[
                Expanded(
                  child: _VolumeCard(
                    label: homeVolumeWeeksDummyData[i].label,
                    value: homeVolumeWeeksDummyData[i].progress,
                    pct: homeVolumeWeeksDummyData[i].percentage,
                  ),
                ),
                if (i < homeVolumeWeeksDummyData.length - 1)
                  const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 72,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children:
                  List.generate(homeVolumeTrajectoryDummyData.length, (i) {
                final isProjected = i >= homeVolumeCompletedDaysDummyData;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 72 * homeVolumeTrajectoryDummyData[i],
                    decoration: BoxDecoration(
                      color: isProjected
                          ? p.secondary.withValues(alpha: 0.55)
                          : p.primary,
                      border: isProjected ? Border.all(color: p.border) : null,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 8,
                      height: 8,
                      child: DecoratedBox(
                          decoration: BoxDecoration(color: p.primary))),
                  const SizedBox(width: 6),
                  Text('Completed'.tr(),
                      style: PumpTextStyles.bodySm(p.mutedForeground)),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                      width: 8,
                      height: 8,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: p.primary.withValues(alpha: 0.3)))),
                  const SizedBox(width: 6),
                  Text('Projected (×1.0)'.tr(),
                      style: PumpTextStyles.label(p.primary)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VolumeCard extends ConsumerWidget {
  final String label;
  final double value;
  final String pct;
  const _VolumeCard(
      {required this.label, required this.value, required this.pct});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: p.secondary, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.tr().toUpperCase(),
              style: PumpTextStyles.label(p.mutedForeground)),
          const SizedBox(height: 8),
          _ProgressBar(value: value),
          const SizedBox(height: 6),
          Text(pct,
              style: PumpTextStyles.bodyLg(p.primary)
                  .copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
