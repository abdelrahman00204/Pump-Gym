import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/dummy_data/workout_schedule_dummy_data.dart';

export 'package:pump_gym/dummy_data/workout_schedule_dummy_data.dart';

final expectedGainMetricsProvider =
    Provider<List<ExpectedGainMetric>>((ref) => expectedGainMetricsDummyData);

final volumeDistributionProvider =
    Provider<List<VolumeDistribution>>((ref) => volumeDistributionDummyData);

final scheduleDaysProvider =
    Provider<List<ScheduleDay>>((ref) => scheduleDaysDummyData);

final workoutProtocolsProvider =
    Provider<List<WorkoutProtocol>>((ref) => workoutProtocolsDummyData);

final selectedProtocolProvider =
    NotifierProvider<SelectedProtocolNotifier, WorkoutProtocol?>(
  SelectedProtocolNotifier.new,
);

class SelectedProtocolNotifier extends Notifier<WorkoutProtocol?> {
  @override
  WorkoutProtocol? build() => null;

  void select(WorkoutProtocol protocol) => state = protocol;

  void clear() => state = null;
}

final scheduleTabProvider =
    NotifierProvider<ScheduleTabNotifier, int>(ScheduleTabNotifier.new);

class ScheduleTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int value) => state = value;
}
