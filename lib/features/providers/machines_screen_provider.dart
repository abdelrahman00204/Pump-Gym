import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/dummy_data/machine_catalog_dummy_data.dart';

export 'package:pump_gym/dummy_data/machine_catalog_dummy_data.dart';

final machineCatalogProvider =
    Provider<List<MachineItem>>((ref) => machineCatalogDummyData);

final machineFiltersProvider =
    Provider<List<String>>((ref) => machineFiltersDummyData);

final machineSearchControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final machineScreenProvider =
    NotifierProvider<MachinesScreenNotifier, MachinesScreenState>(
  MachinesScreenNotifier.new,
);

final filteredMachinesProvider = Provider<List<MachineItem>>((ref) {
  final state = ref.watch(machineScreenProvider);
  final catalog = ref.watch(machineCatalogProvider);
  final selectedFilter = machineFiltersDummyData[state.selectedFilter];
  final query = state.query.trim().toLowerCase();

  return catalog.where((machine) {
    final matchesCategory = selectedFilter == 'All' ||
        machine.primaryMuscle.toLowerCase() == selectedFilter.toLowerCase();
    final searchableText = [
      machine.name,
      machine.category,
      machine.primaryMuscle,
      ...machine.searchTerms,
    ].join(' ').toLowerCase();
    return matchesCategory && (query.isEmpty || searchableText.contains(query));
  }).toList();
});

class MachinesScreenState {
  final int selectedFilter;
  final bool gridView;
  final String query;
  final String? expandedMachine;

  const MachinesScreenState({
    this.selectedFilter = 0,
    this.gridView = true,
    this.query = '',
    this.expandedMachine,
  });

  MachinesScreenState copyWith({
    int? selectedFilter,
    bool? gridView,
    String? query,
    String? expandedMachine,
  }) =>
      MachinesScreenState(
        selectedFilter: selectedFilter ?? this.selectedFilter,
        gridView: gridView ?? this.gridView,
        query: query ?? this.query,
        expandedMachine: expandedMachine ?? this.expandedMachine,
      );
}

class MachinesScreenNotifier extends Notifier<MachinesScreenState> {
  @override
  MachinesScreenState build() => const MachinesScreenState();

  void selectFilter(int value) {
    if (value < 0 || value >= machineFiltersDummyData.length) return;
    state = state.copyWith(selectedFilter: value);
  }

  void toggleView(bool value) => state = state.copyWith(gridView: value);

  void search(String value) => state = state.copyWith(query: value);

  void toggleExpanded(String machineName) {
    state = MachinesScreenState(
      selectedFilter: state.selectedFilter,
      gridView: state.gridView,
      query: state.query,
      expandedMachine:
          state.expandedMachine == machineName ? null : machineName,
    );
  }
}
