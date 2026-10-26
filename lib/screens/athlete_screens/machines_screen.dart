import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/theme/pump_theme.dart';
import 'package:pump_gym/theme/theme_provider.dart';
import 'package:pump_gym/widgets/session_running.dart';
import 'package:pump_gym/widgets/top_bar.dart';
import 'package:pump_gym/features/providers/machines_screen_provider.dart';
import 'package:pump_gym/features/providers/session_provider.dart';
import 'package:pump_gym/constants/app_routes.dart';
import 'package:pump_gym/wide_layout.dart';

class MachinesScreen extends ConsumerStatefulWidget {
  const MachinesScreen({super.key});

  @override
  ConsumerState<MachinesScreen> createState() => _MachinesScreenState();
}

class _MachinesScreenState extends ConsumerState<MachinesScreen> {
  @override
  Widget build(BuildContext context) {
    final p = ref.watch(pumpPaletteProvider);
    final screenState = ref.watch(machineScreenProvider);
    final filters = ref.watch(machineFiltersProvider);
    final filteredMachines = ref.watch(filteredMachinesProvider);

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
                      const _GateVerifiedBanner(),
                      const SizedBox(height: PumpSpacing.md),
                      _SearchField(
                        value: screenState.query,
                        onChanged: (value) => ref
                            .read(machineScreenProvider.notifier)
                            .search(value),
                      ),
                      const SizedBox(height: PumpSpacing.md),
                      _FilterRow(
                        filters: filters,
                        selected: screenState.selectedFilter,
                        onSelect: (i) => ref
                            .read(machineScreenProvider.notifier)
                            .selectFilter(i),
                        gridView: screenState.gridView,
                        onToggleView: (v) => ref
                            .read(machineScreenProvider.notifier)
                            .toggleView(v),
                      ),
                      const SizedBox(height: PumpSpacing.lg),
                      if (filteredMachines.isEmpty)
                        const _EmptyMachineResults()
                      else if (screenState.gridView)
                        _MachinesGrid(items: filteredMachines)
                      else
                        _MachinesList(items: filteredMachines),
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
// Gate verified banner
// ---------------------------------------------------------------------------
class _GateVerifiedBanner extends ConsumerWidget {
  const _GateVerifiedBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: p.primary.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(PumpRadius.pill),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
            child: Icon(Icons.check, size: 14, color: p.primaryForeground),
          ),
          const SizedBox(width: PumpSpacing.sm),
          Text('GATE VERIFIED — EQUIPMENT UNLOCKED'.tr(),
              style:
                  PumpTextStyles.label(p.primary).copyWith(letterSpacing: 0.3)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search field
// ---------------------------------------------------------------------------
class _SearchField extends ConsumerWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: p.secondary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(children: [
        Icon(Icons.search, color: p.mutedForeground, size: 20),
        const SizedBox(width: PumpSpacing.sm),
        Expanded(
          child: TextField(
            onChanged: onChanged,
            controller: ref.watch(machineSearchControllerProvider),
            style: PumpTextStyles.bodyMd(p.foreground),
            decoration: InputDecoration(
              hintText: 'Search machine, muscle, category...'.tr(),
              hintStyle: PumpTextStyles.bodySm(p.mutedForeground),
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        if (value.isNotEmpty)
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              ref.read(machineSearchControllerProvider).clear();
              onChanged('');
            },
            icon: Icon(Icons.close, color: p.mutedForeground, size: 18),
          ),
      ]),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter row
// ---------------------------------------------------------------------------
class _FilterRow extends ConsumerWidget {
  final List<String> filters;
  final int selected;
  final ValueChanged<int> onSelect;
  final bool gridView;
  final ValueChanged<bool> onToggleView;

  const _FilterRow({
    required this.filters,
    required this.selected,
    required this.onSelect,
    required this.gridView,
    required this.onToggleView,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: PumpSpacing.xs),
              itemBuilder: (context, i) {
                final isSelected = i == selected;
                return GestureDetector(
                  onTap: () => onSelect(i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? p.primary : p.surface,
                      border:
                          Border.all(color: isSelected ? p.primary : p.border),
                      borderRadius: BorderRadius.circular(PumpRadius.pill),
                    ),
                    child: Text(
                      filters[i].tr().toUpperCase(),
                      style: PumpTextStyles.label(
                        isSelected ? p.primaryForeground : p.mutedForeground,
                      ).copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: PumpSpacing.xs),
          GestureDetector(
            onTap: () => onToggleView(true),
            child: _IconPill(icon: Icons.grid_view, isSelected: gridView),
          ),
          const SizedBox(width: PumpSpacing.xs),
          GestureDetector(
            onTap: () => onToggleView(false),
            child: _IconPill(icon: Icons.view_list, isSelected: !gridView),
          ),
        ],
      ),
    );
  }
}

class _IconPill extends ConsumerWidget {
  final IconData icon;
  final bool isSelected;
  const _IconPill({required this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isSelected ? p.primary : p.surface,
        border: Border.all(color: isSelected ? p.primary : p.border),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: isSelected ? p.primaryForeground : p.foreground,
        size: 18,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Grid of machine cards (2 columns)
// ---------------------------------------------------------------------------
class _MachinesGrid extends StatelessWidget {
  final List<MachineItem> items;
  const _MachinesGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return PumpCardGrid(
      compact: 2,
      medium: 2,
      expanded: 4,
      spacing: PumpSpacing.sm,
      children: [for (final item in items) _MachineCard(item: item)],
    );
  }
}

class _MachineCard extends ConsumerWidget {
  final MachineItem item;
  const _MachineCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final screenState = ref.watch(machineScreenProvider);
    final expanded = screenState.expandedMachine == item.name;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 72,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [p.secondary, p.background],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(item.icon, color: p.primary, size: 36),
              ),
            ),
          ),
          const SizedBox(height: PumpSpacing.sm),
          Text(item.name.tr(),
              style: PumpTextStyles.bodyMd(p.foreground)
                  .copyWith(fontWeight: FontWeight.bold, height: 1.2)),
          const SizedBox(height: PumpSpacing.xs),
          Text(item.category.tr(),
              style: PumpTextStyles.label(p.mutedForeground)
                  .copyWith(letterSpacing: 0.3),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: PumpSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                    'LAST {weight}'.tr(namedArgs: {
                      'weight': item.lastWeight,
                    }),
                    style: PumpTextStyles.label(p.mutedForeground)),
              ),
              if (item.prWeight != '—')
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: p.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(item.prWeight,
                      style: PumpTextStyles.label(p.primary)
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: PumpSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(sessionUiProvider.notifier).startForMachine(
                      machine: item.name,
                      weight: item.startingWeight,
                      muscleGroup: item.primaryMuscle,
                      targetSets: item.targetSets,
                    );
                ref.read(sessionStartProvider.notifier).startNew();
                context.go(AppRoutes.session);
              },
              icon:
                  Icon(Icons.play_arrow, color: p.primaryForeground, size: 16),
              label: Text('Start Station Workout'.tr(),
                  textAlign: TextAlign.center,
                  style: PumpTextStyles.label(p.primaryForeground)
                      .copyWith(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: p.primary,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: PumpSpacing.xs),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => ref
                  .read(machineScreenProvider.notifier)
                  .toggleExpanded(item.name),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: p.border),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(expanded ? Icons.expand_less : Icons.expand_more,
                      size: 14, color: p.foreground),
                  const SizedBox(width: 5),
                  Text(
                      (expanded ? 'Hide Biomechanics' : 'Expand Biomechanics')
                          .tr(),
                      textAlign: TextAlign.center,
                      style: PumpTextStyles.label(p.foreground)
                          .copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: PumpSpacing.sm),
            Divider(color: p.border),
            _MachineBiomechanics(item: item),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// List view alternative
// ---------------------------------------------------------------------------
class _MachinesList extends StatelessWidget {
  final List<MachineItem> items;
  const _MachinesList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((m) => Padding(
                padding: const EdgeInsets.only(bottom: PumpSpacing.sm),
                child: _MachineCard(item: m),
              ))
          .toList(),
    );
  }
}

class _MachineBiomechanics extends ConsumerWidget {
  final MachineItem item;
  const _MachineBiomechanics({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('EXECUTION STEPS'.tr(),
            style: PumpTextStyles.label(p.mutedForeground)),
        const SizedBox(height: 5),
        for (var i = 0; i < item.executionSteps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text('${i + 1}. ${item.executionSteps[i].tr()}',
                style: PumpTextStyles.bodySm(p.mutedForeground)
                    .copyWith(fontSize: 10, height: 1.3)),
          ),
        const SizedBox(height: 5),
        Text('SAFETY'.tr(), style: PumpTextStyles.label(p.mutedForeground)),
        const SizedBox(height: 5),
        Text(item.safety.tr(),
            style: PumpTextStyles.bodySm(p.mutedForeground)
                .copyWith(fontSize: 10, height: 1.3)),
        const SizedBox(height: 8),
        Text('ALTERNATIVES'.tr(),
            style: PumpTextStyles.label(p.mutedForeground)),
        const SizedBox(height: 5),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: item.alternatives
              .map((name) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: p.border),
                      borderRadius: BorderRadius.circular(PumpRadius.pill),
                    ),
                    child: Text(name.tr().toUpperCase(),
                        style: PumpTextStyles.label(p.mutedForeground)
                            .copyWith(fontSize: 8, letterSpacing: .5)),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _EmptyMachineResults extends ConsumerWidget {
  const _EmptyMachineResults();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text('No stations match your search.'.tr(),
            style: PumpTextStyles.bodyMd(p.mutedForeground)),
      ),
    );
  }
}
