import 'athlete_profile_dummy_data.dart';

enum WorkoutIntensity { peak, high, moderate, rest }

class WorkoutHistoryDayDummyData {
  final String workout;
  final WorkoutIntensity intensity;
  final int volumeLbs;

  const WorkoutHistoryDayDummyData({
    required this.workout,
    required this.intensity,
    required this.volumeLbs,
  });
}

class WorkoutHistoryStatDummyData {
  final String value;
  final String label;

  const WorkoutHistoryStatDummyData(this.value, this.label);
}

const workoutHistoryDaysDummyData = <WorkoutHistoryDayDummyData>[
  WorkoutHistoryDayDummyData(
      workout: 'Push Day', intensity: WorkoutIntensity.high, volumeLbs: 4337),
  WorkoutHistoryDayDummyData(
      workout: 'Legs Day', intensity: WorkoutIntensity.peak, volumeLbs: 4474),
  WorkoutHistoryDayDummyData(
      workout: 'Upper Power',
      intensity: WorkoutIntensity.moderate,
      volumeLbs: 4611),
  WorkoutHistoryDayDummyData(
      workout: 'Rest', intensity: WorkoutIntensity.rest, volumeLbs: 0),
  WorkoutHistoryDayDummyData(
      workout: 'Pull Day', intensity: WorkoutIntensity.high, volumeLbs: 4865),
  WorkoutHistoryDayDummyData(
      workout: 'Legs Day', intensity: WorkoutIntensity.peak, volumeLbs: 5022),
  WorkoutHistoryDayDummyData(
      workout: 'Rest', intensity: WorkoutIntensity.rest, volumeLbs: 0),
  WorkoutHistoryDayDummyData(
      workout: 'Push Day',
      intensity: WorkoutIntensity.moderate,
      volumeLbs: 5296),
  WorkoutHistoryDayDummyData(
      workout: 'Pull Day', intensity: WorkoutIntensity.high, volumeLbs: 5433),
  WorkoutHistoryDayDummyData(
      workout: 'Legs Day', intensity: WorkoutIntensity.peak, volumeLbs: 5570),
  WorkoutHistoryDayDummyData(
      workout: 'Rest', intensity: WorkoutIntensity.rest, volumeLbs: 0),
  WorkoutHistoryDayDummyData(
      workout: 'Push Day', intensity: WorkoutIntensity.high, volumeLbs: 5844),
  WorkoutHistoryDayDummyData(
      workout: 'Pull Day',
      intensity: WorkoutIntensity.moderate,
      volumeLbs: 14750),
  WorkoutHistoryDayDummyData(
      workout: 'Rest', intensity: WorkoutIntensity.rest, volumeLbs: 0),
  WorkoutHistoryDayDummyData(
      workout: 'Upper Power',
      intensity: WorkoutIntensity.peak,
      volumeLbs: 6255),
  WorkoutHistoryDayDummyData(
      workout: 'Push Day', intensity: WorkoutIntensity.high, volumeLbs: 6392),
  WorkoutHistoryDayDummyData(
      workout: 'Pull Day',
      intensity: WorkoutIntensity.moderate,
      volumeLbs: 6529),
  WorkoutHistoryDayDummyData(
      workout: 'Rest', intensity: WorkoutIntensity.rest, volumeLbs: 0),
  WorkoutHistoryDayDummyData(
      workout: 'Upper Power',
      intensity: WorkoutIntensity.high,
      volumeLbs: 6803),
  WorkoutHistoryDayDummyData(
      workout: 'Push Day', intensity: WorkoutIntensity.peak, volumeLbs: 6940),
  WorkoutHistoryDayDummyData(
      workout: 'Rest', intensity: WorkoutIntensity.rest, volumeLbs: 0),
  WorkoutHistoryDayDummyData(
      workout: 'Legs Day',
      intensity: WorkoutIntensity.moderate,
      volumeLbs: 7214),
  WorkoutHistoryDayDummyData(
      workout: 'Upper Power',
      intensity: WorkoutIntensity.high,
      volumeLbs: 7351),
  WorkoutHistoryDayDummyData(
      workout: 'Push Day', intensity: WorkoutIntensity.high, volumeLbs: 7488),
  WorkoutHistoryDayDummyData(
      workout: 'Rest', intensity: WorkoutIntensity.rest, volumeLbs: 0),
  WorkoutHistoryDayDummyData(
      workout: 'Legs Day',
      intensity: WorkoutIntensity.moderate,
      volumeLbs: 7762),
  WorkoutHistoryDayDummyData(
      workout: 'Upper Power',
      intensity: WorkoutIntensity.high,
      volumeLbs: 7899),
  WorkoutHistoryDayDummyData(
      workout: 'Rest', intensity: WorkoutIntensity.rest, volumeLbs: 0),
  WorkoutHistoryDayDummyData(
      workout: 'Pull Day', intensity: WorkoutIntensity.peak, volumeLbs: 8173),
  WorkoutHistoryDayDummyData(
      workout: 'Legs Day', intensity: WorkoutIntensity.high, volumeLbs: 8310),
];

const workoutHistoryStatsDummyData = <WorkoutHistoryStatDummyData>[
  WorkoutHistoryStatDummyData('22', 'WORKOUTS'),
  WorkoutHistoryStatDummyData('73.7T', 'TONNAGE'),
  WorkoutHistoryStatDummyData('66%', 'AVG INTENSITY'),
  WorkoutHistoryStatDummyData('6', 'PR'),
  WorkoutHistoryStatDummyData('9', 'STREAK'),
  WorkoutHistoryStatDummyData('8', 'REST DAYS'),
];

const workoutHistoryMatrixIntensitiesDummyData = <WorkoutIntensity>[
  WorkoutIntensity.moderate,
  WorkoutIntensity.peak,
  WorkoutIntensity.high,
  WorkoutIntensity.rest,
  WorkoutIntensity.moderate,
  WorkoutIntensity.peak,
  WorkoutIntensity.rest,
  WorkoutIntensity.moderate,
  WorkoutIntensity.high,
  WorkoutIntensity.peak,
  WorkoutIntensity.rest,
  WorkoutIntensity.moderate,
  WorkoutIntensity.high,
  WorkoutIntensity.rest,
  WorkoutIntensity.peak,
  WorkoutIntensity.moderate,
  WorkoutIntensity.high,
  WorkoutIntensity.rest,
  WorkoutIntensity.moderate,
  WorkoutIntensity.peak,
  WorkoutIntensity.rest,
  WorkoutIntensity.moderate,
  WorkoutIntensity.high,
  WorkoutIntensity.moderate,
  WorkoutIntensity.rest,
  WorkoutIntensity.high,
  WorkoutIntensity.moderate,
  WorkoutIntensity.rest,
  WorkoutIntensity.peak,
  WorkoutIntensity.moderate,
];

const workoutHistoryBestDayDummyData = 'Day 13';
const workoutHistoryLongestStreakDummyData = 9;
const workoutHistoryProfileDummyData = athleteProfileDummyData;
