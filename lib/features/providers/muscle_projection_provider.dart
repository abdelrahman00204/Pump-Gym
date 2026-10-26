import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/dummy_data/muscle_projection_dummy_data.dart';

export 'package:pump_gym/dummy_data/muscle_projection_dummy_data.dart';

final selectedMuscleGroupProvider =
    NotifierProvider<SelectedMuscleGroupNotifier, String>(
  SelectedMuscleGroupNotifier.new,
);

class SelectedMuscleGroupNotifier extends Notifier<String> {
  @override
  String build() => muscleGroupsDummyData.first;

  void select(String group) {
    if (musclesByGroupDummyData.containsKey(group)) state = group;
  }
}
