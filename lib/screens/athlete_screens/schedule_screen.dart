import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/dummy_data/home_dashboard_dummy_data.dart';
import 'package:pump_gym/widgets/session_running.dart';
import 'package:pump_gym/widgets/top_bar.dart';
import 'package:pump_gym/features/providers/schedule_screen_provider.dart';
import 'package:pump_gym/widgets/schedule_content_widgets.dart';
import 'package:pump_gym/wide_layout.dart';

import '../../../theme/pump_theme.dart';
import '../../../theme/theme_provider.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    final p = ref.watch(pumpPaletteProvider);
    final selectedTab = ref.watch(scheduleTabProvider);
    final days = ref.watch(scheduleDaysProvider);

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
                      child: const TopBar(canPop: false),
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
                      const _ActiveProgramCard(),
                      const SizedBox(height: PumpSpacing.lg),
                      _TabRow(
                        selected: selectedTab,
                        onSelect: (i) =>
                            ref.read(scheduleTabProvider.notifier).select(i),
                      ),
                      const SizedBox(height: PumpSpacing.lg),
                      if (selectedTab == 0) ...[
                        _ScheduleGrid(days: days),
                        const SizedBox(height: PumpSpacing.md),
                        const _LegendRow(),
                      ] else if (selectedTab == 1) ...[
                        const ExpectedGainsView(),
                      ] else ...[
                        ProtocolLibraryView(
                          onInspect: _inspectProtocol,
                        ),
                      ],
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

  Future<void> _inspectProtocol(WorkoutProtocol protocol) async {
    ref.read(selectedProtocolProvider.notifier).select(protocol);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Consumer(
        builder: (context, ref, _) {
          final selectedProtocol = ref.watch(selectedProtocolProvider);
          if (selectedProtocol == null) return const SizedBox.shrink();
          return FractionallySizedBox(
            heightFactor: .94,
            child: ProtocolDetailSheet(protocol: selectedProtocol),
          );
        },
      ),
    );
    if (mounted) ref.read(selectedProtocolProvider.notifier).clear();
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
// Active program card
// ---------------------------------------------------------------------------
class _ActiveProgramCard extends ConsumerWidget {
  const _ActiveProgramCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final activeProtocol = workoutProtocolsDummyData.first;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.primary.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: p.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(PumpRadius.pill),
                ),
                child: Text('ACTIVE PROGRAM'.tr(),
                    style: PumpTextStyles.label(p.primary)),
              ),
              const Spacer(),
              Text(
                  'WEEK {current} / {total}'.tr(namedArgs: {
                    'current': '$activeProtocolWeekDummyData',
                    'total': '$activeProtocolTotalWeeksDummyData',
                  }),
                  style: PumpTextStyles.label(p.mutedForeground)),
            ],
          ),
          const SizedBox(height: PumpSpacing.md),
          Text(activeProtocol.title.toUpperCase(),
              style: PumpTextStyles.displayXl(p.foreground)),
          const SizedBox(height: PumpSpacing.sm),
          Text(
              'Coach: {coach} · Assigned by Admin'.tr(namedArgs: {
                'coach': activeProtocol.coach,
              }),
              style: PumpTextStyles.bodySm(p.mutedForeground)),
          const SizedBox(height: PumpSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: homeDashboardProtocolCompletionDummyData,
              minHeight: 8,
              backgroundColor: p.secondary,
              valueColor: AlwaysStoppedAnimation(p.primary),
            ),
          ),
          const SizedBox(height: PumpSpacing.sm),
          Row(
            children: [
              Text('PROGRESS'.tr(),
                  style: PumpTextStyles.label(p.mutedForeground)),
              const Spacer(),
              Text(
                  '${(homeDashboardProtocolCompletionDummyData * 100).round()}%',
                  style: PumpTextStyles.bodyLg(p.primary)
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab row
// ---------------------------------------------------------------------------
class _TabRow extends ConsumerWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _TabRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final tabs = ['30-Day Schedule', 'Expected Gains', 'Protocols Library'];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: PumpSpacing.sm),
        itemBuilder: (context, i) {
          final isSelected = i == selected;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? p.primary : p.surface,
                border: Border.all(color: isSelected ? p.primary : p.border),
                borderRadius: BorderRadius.circular(PumpRadius.pill),
              ),
              child: Text(
                tabs[i].toUpperCase(),
                style: PumpTextStyles.label(
                  isSelected ? p.primaryForeground : p.mutedForeground,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 30-day grid
// ---------------------------------------------------------------------------
class _ScheduleGrid extends StatelessWidget {
  final List<ScheduleDay> days;
  const _ScheduleGrid({required this.days});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: days.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: PumpSpacing.sm.w,
          mainAxisSpacing: PumpSpacing.sm.h,
          mainAxisExtent: 72.h,
        ),
        itemBuilder: (context, i) => _DayCell(day: days[i]),
      ),
    );
  }
}

class _DayCell extends ConsumerWidget {
  final ScheduleDay day;
  const _DayCell({required this.day});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    late BoxDecoration decoration;
    Color numberColor = p.foreground;
    Color labelColor = p.primaryForeground;

    switch (day.variant) {
      case ScheduleDayVariant.push:
        decoration = BoxDecoration(
          color: p.primary,
          borderRadius: BorderRadius.circular(16),
        );
        numberColor = p.primaryForeground;
        labelColor = p.primaryForeground;
        break;
      case ScheduleDayVariant.pull:
        decoration = BoxDecoration(
          color: p.primary.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
        );
        numberColor = p.primaryForeground;
        labelColor = p.primaryForeground;
        break;
      case ScheduleDayVariant.legs:
        decoration = BoxDecoration(
          color: p.secondary,
          borderRadius: BorderRadius.circular(16),
        );
        numberColor = p.foreground;
        labelColor = p.mutedForeground;
        break;
      case ScheduleDayVariant.upperOutline:
        decoration = BoxDecoration(
          color: p.surface,
          border: Border.all(color: p.primary, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        );
        numberColor = p.foreground;
        labelColor = p.primary;
        break;
      case ScheduleDayVariant.upperMuted:
        decoration = BoxDecoration(
          color: p.secondary,
          borderRadius: BorderRadius.circular(16),
        );
        numberColor = p.mutedForeground;
        labelColor = p.mutedForeground;
        break;
      case ScheduleDayVariant.rest:
        decoration = BoxDecoration(
          border: Border.all(color: p.border, width: 1),
          borderRadius: BorderRadius.circular(16),
        );
        numberColor = p.mutedForeground;
        labelColor = p.mutedForeground;
        break;
    }

    return Container(
      decoration: decoration,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.number}',
            style: TextStyle(
              color: numberColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (day.label != null) ...[
            const SizedBox(height: 2),
            Text(
              day.label!.tr(),
              style: TextStyle(
                color: labelColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Legend
// ---------------------------------------------------------------------------
class _LegendRow extends ConsumerWidget {
  const _LegendRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final items = [
      {'label': 'Push', 'color': p.primary, 'text': p.primaryForeground},
      {
        'label': 'Pull',
        'color': p.primary.withValues(alpha: 0.8),
        'text': p.primaryForeground
      },
      {'label': 'Legs', 'color': p.secondary, 'text': p.foreground},
      {'label': 'Upper', 'color': p.secondary, 'text': p.mutedForeground},
      {'label': 'Rest', 'color': Colors.transparent, 'text': p.mutedForeground},
    ];

    return Wrap(
      spacing: PumpSpacing.sm,
      runSpacing: PumpSpacing.sm,
      children: items.map((item) {
        final isRest = item['label'] == 'Rest';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: item['color'] as Color,
            border: isRest ? Border.all(color: p.border) : null,
            borderRadius: BorderRadius.circular(PumpRadius.pill),
          ),
          child: Text(
            (item['label'] as String).toUpperCase(),
            style: PumpTextStyles.label(item['text'] as Color),
          ),
        );
      }).toList(),
    );
  }
}
