import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/dummy_data/session_dummy_data.dart';

/// The session start time is kept outside the screen so route changes don't
/// reset the elapsed timer.
final sessionStartProvider =
    NotifierProvider<SessionStartNotifier, DateTime?>(SessionStartNotifier.new);

final sessionElapsedProvider = StreamProvider.autoDispose<int>((ref) {
  final startedAt = ref.watch(sessionStartProvider);
  return Stream.periodic(
      const Duration(seconds: 1),
      (_) => startedAt == null
          ? 0
          : DateTime.now().difference(startedAt).inSeconds);
});

class SessionStartNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  void startIfNeeded() {
    state ??= DateTime.now();
  }

  void startNew() {
    state = DateTime.now();
  }

  void finish() {
    state = null;
  }
}

final sessionUiProvider =
    NotifierProvider<SessionUiNotifier, SessionUiState>(SessionUiNotifier.new);

class SessionUiState {
  final int selectedMuscleGroup;
  final int weight;
  final int reps;
  final int loggedSets;
  final String machine;
  final List<String> additionalMachines;
  final bool stationWorkout;
  final String? stationMuscleGroup;
  final int stationTargetSets;

  const SessionUiState({
    this.selectedMuscleGroup = 0,
    this.weight = sessionDefaultWeightDummyData,
    this.reps = sessionDefaultRepsDummyData,
    this.loggedSets = 0,
    this.machine = sessionDefaultMachineDummyData,
    this.additionalMachines = const [],
    this.stationWorkout = false,
    this.stationMuscleGroup,
    this.stationTargetSets = sessionDefaultSetTargetDummyData,
  });

  SessionUiState copyWith({
    int? selectedMuscleGroup,
    int? weight,
    int? reps,
    int? loggedSets,
    String? machine,
    List<String>? additionalMachines,
    bool? stationWorkout,
    String? stationMuscleGroup,
    int? stationTargetSets,
  }) =>
      SessionUiState(
        selectedMuscleGroup: selectedMuscleGroup ?? this.selectedMuscleGroup,
        weight: weight ?? this.weight,
        reps: reps ?? this.reps,
        loggedSets: loggedSets ?? this.loggedSets,
        machine: machine ?? this.machine,
        additionalMachines: additionalMachines ?? this.additionalMachines,
        stationWorkout: stationWorkout ?? this.stationWorkout,
        stationMuscleGroup: stationMuscleGroup ?? this.stationMuscleGroup,
        stationTargetSets: stationTargetSets ?? this.stationTargetSets,
      );
}

class SessionUiNotifier extends Notifier<SessionUiState> {
  @override
  SessionUiState build() => const SessionUiState();

  void selectMuscleGroup(int value) =>
      state = state.copyWith(selectedMuscleGroup: value);

  void adjustWeight(int delta) => state = state.copyWith(
        weight: (state.weight + delta).clamp(0, 999).toInt(),
      );

  void adjustReps(int delta) => state = state.copyWith(
        reps: (state.reps + delta).clamp(1, 99).toInt(),
      );

  void logSet({int setLimit = sessionDefaultSetTargetDummyData}) {
    if (state.loggedSets < setLimit) {
      state = state.copyWith(loggedSets: state.loggedSets + 1);
    }
  }

  void swapMachine(String machine) =>
      state = state.copyWith(machine: machine, loggedSets: 0);

  void addMachine(String machine) => state = state.copyWith(
        additionalMachines: [...state.additionalMachines, machine],
      );

  void startForMachine({
    required String machine,
    required int weight,
    required String muscleGroup,
    required int targetSets,
  }) {
    state = SessionUiState(
      machine: machine,
      weight: weight,
      reps: sessionDefaultRepsDummyData,
      stationWorkout: true,
      stationMuscleGroup: muscleGroup,
      stationTargetSets: targetSets,
    );
  }

  void reset() => state = const SessionUiState();
}
