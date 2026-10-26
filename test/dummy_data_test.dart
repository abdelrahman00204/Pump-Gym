import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pump_gym/dummy_data/leaderboard_dummy_data.dart';
import 'package:pump_gym/dummy_data/workout_history_dummy_data.dart';
import 'package:pump_gym/dummy_data/workout_schedule_dummy_data.dart';

void main() {
  test('workout history and schedule fixtures each cover 30 days', () {
    expect(workoutHistoryDaysDummyData, hasLength(30));
    expect(workoutHistoryMatrixIntensitiesDummyData, hasLength(30));
    expect(scheduleDaysDummyData, hasLength(30));
  });

  test('leaderboard fixture randomizes assignments and leaves one tier empty',
      () {
    final entries = createLeaderboardDummyData(random: Random(1));
    final tierCounts = {
      for (final tier in ['S', 'A', 'B', 'C'])
        tier: entries.where((entry) => entry.tier == tier).length,
    };

    expect(entries, hasLength(5));
    expect(tierCounts.values.where((count) => count == 0), hasLength(1));
    expect(tierCounts.values.where((count) => count > 0), hasLength(3));
  });
}
