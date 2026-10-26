import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/dummy_data/leaderboard_dummy_data.dart';
import 'package:pump_gym/theme/pump_theme.dart';
import 'package:pump_gym/theme/theme_provider.dart';
import 'package:pump_gym/widgets/session_running.dart';
import 'package:pump_gym/widgets/top_bar.dart';
import 'package:pump_gym/features/providers/leaderboard_screen_provider.dart';
import 'package:pump_gym/wide_layout.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    final p = ref.watch(pumpPaletteProvider);
    final mainTab = ref.watch(leaderboardMainTabProvider);
    final tierFilter = ref.watch(leaderboardTierFilterProvider);
    final timeFilter = ref.watch(leaderboardTimeFilterProvider);

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
                      _MainTabRow(
                        selected: mainTab,
                        onSelect: (i) => ref
                            .read(leaderboardMainTabProvider.notifier)
                            .select(i),
                      ),
                      const SizedBox(height: PumpSpacing.md),
                      _ChipRow(
                        labels: const ['All', 'S', 'A', 'B', 'C'],
                        selected: tierFilter,
                        onSelect: (i) => ref
                            .read(leaderboardTierFilterProvider.notifier)
                            .select(i),
                      ),
                      const SizedBox(height: PumpSpacing.sm),
                      _ChipRow(
                        labels: const ['Week', 'Month', 'All-Time'],
                        selected: timeFilter,
                        onSelect: (i) => ref
                            .read(leaderboardTimeFilterProvider.notifier)
                            .select(i),
                        expand: true,
                      ),
                      const SizedBox(height: PumpSpacing.lg),
                      _LeaderboardCard(tierFilter: tierFilter),
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
// Main tab row (Global Rank / Private Squads)
// ---------------------------------------------------------------------------
class _MainTabRow extends ConsumerWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _MainTabRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final labels = ['Global Rank', 'Private Squads'];

    return Row(
      children: [
        for (int i = 0; i < labels.length; i++) ...[
          Expanded(
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected == i ? p.primary : p.surface,
                  border:
                      Border.all(color: selected == i ? p.primary : p.border),
                  borderRadius: BorderRadius.circular(PumpRadius.pill),
                ),
                child: Text(
                  labels[i].tr().toUpperCase(),
                  style: PumpTextStyles.label(
                    selected == i ? p.primaryForeground : p.mutedForeground,
                  ).copyWith(
                    fontWeight:
                        selected == i ? FontWeight.bold : FontWeight.normal,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
          if (i != labels.length - 1) const SizedBox(width: PumpSpacing.sm),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Generic pill filter row
// ---------------------------------------------------------------------------
class _ChipRow extends ConsumerWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelect;
  final bool expand;
  const _ChipRow({
    required this.labels,
    required this.selected,
    required this.onSelect,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    final chips = List.generate(labels.length, (i) {
      final isSelected = i == selected;
      final chip = GestureDetector(
        onTap: () => onSelect(i),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? p.primary : p.surface,
            border: Border.all(color: isSelected ? p.primary : p.border),
            borderRadius: BorderRadius.circular(PumpRadius.pill),
          ),
          child: Text(
            labels[i].tr().toUpperCase(),
            style: PumpTextStyles.label(
              isSelected ? p.primaryForeground : p.mutedForeground,
            ).copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              letterSpacing: 0.3,
            ),
          ),
        ),
      );
      return expand ? Expanded(child: chip) : chip;
    });

    if (expand) {
      return Row(
        children: [
          for (int i = 0; i < chips.length; i++) ...[
            chips[i],
            if (i != chips.length - 1) const SizedBox(width: PumpSpacing.sm),
          ],
        ],
      );
    }

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: PumpSpacing.sm),
        itemBuilder: (context, i) => chips[i],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Leaderboard card
// ---------------------------------------------------------------------------
class _LeaderboardCard extends ConsumerWidget {
  final int tierFilter;

  const _LeaderboardCard({required this.tierFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final entries = tierFilter == 0
        ? leaderboardDummyData
        : leaderboardDummyData
            .where((entry) =>
                entry.tier == const ['S', 'A', 'B', 'C'][tierFilter - 1])
            .toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      child: Column(
        children: [
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: PumpSpacing.lg),
              child: Text(
                'No athletes in this tier yet.'.tr(),
                style: PumpTextStyles.bodyMd(p.mutedForeground),
              ),
            ),
          for (int i = 0; i < entries.length; i++) ...[
            _LeaderboardRow(entry: entries[i]),
            if (i != entries.length - 1) const SizedBox(height: PumpSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _LeaderboardRow extends ConsumerWidget {
  final LeaderboardEntry entry;
  const _LeaderboardRow({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: p.secondary,
        border: Border.all(
            color: entry.isCurrentUser ? p.primary : Colors.transparent,
            width: 1.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 36,
            child: Text('#${entry.rank}',
                style: PumpTextStyles.bodyLg(p.primary)
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: p.primary, width: 1.5),
            ),
            child: CircleAvatar(
              backgroundColor: p.secondary,
              child: Icon(Icons.person, size: 20, color: p.mutedForeground),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(entry.name,
                          overflow: TextOverflow.ellipsis,
                          style: PumpTextStyles.bodyMd(p.foreground).copyWith(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.verified, size: 14, color: p.primary),
                  ],
                ),
                const SizedBox(height: 2),
                Text(entry.tierLabel,
                    style: PumpTextStyles.label(p.mutedForeground)
                        .copyWith(letterSpacing: 0.3)),
              ],
            ),
          ),
          Text(
            entry.score.toString().replaceAllMapped(
                RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'),
            style: PumpTextStyles.bodyLg(p.primary)
                .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
