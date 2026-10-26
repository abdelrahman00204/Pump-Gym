enum ScheduleDayVariant { push, pull, legs, upperOutline, upperMuted, rest }

class ScheduleDay {
  final int number;
  final String? label;
  final ScheduleDayVariant variant;

  const ScheduleDay(this.number, this.label, this.variant);
}

class ProtocolSampleExercise {
  final String name;
  final String prescription;

  const ProtocolSampleExercise(this.name, this.prescription);
}

class WorkoutProtocol {
  final String title;
  final String category;
  final String difficulty;
  final String duration;
  final String price;
  final String expectedGain;
  final int enrolledAthletes;
  final double averageCompletion;
  final int trainingDays;
  final int stations;
  final int totalSets;
  final String coach;
  final List<ProtocolSampleExercise> sampleExercises;

  const WorkoutProtocol({
    required this.title,
    required this.category,
    required this.difficulty,
    required this.duration,
    required this.price,
    required this.expectedGain,
    required this.enrolledAthletes,
    required this.averageCompletion,
    required this.trainingDays,
    required this.stations,
    required this.totalSets,
    required this.coach,
    required this.sampleExercises,
  });
}

class ExpectedGainMetric {
  final String value;
  final String label;

  const ExpectedGainMetric(this.value, this.label);
}

class VolumeDistribution {
  final String group;
  final double value;
  final String percent;

  const VolumeDistribution(this.group, this.value, this.percent);
}

const expectedGainMetricsDummyData = <ExpectedGainMetric>[
  ExpectedGainMetric('+2.4 KG', 'MUSCLE MASS'),
  ExpectedGainMetric('+18%', 'STRENGTH SURGE'),
  ExpectedGainMetric('+950', 'POWER BOOST'),
  ExpectedGainMetric('84T', 'TOTAL VOLUME'),
];

const volumeDistributionDummyData = <VolumeDistribution>[
  VolumeDistribution('Chest', .78, '22%'),
  VolumeDistribution('Back', .74, '21%'),
  VolumeDistribution('Legs', .91, '26%'),
  VolumeDistribution('Shoulders', .52, '16%'),
  VolumeDistribution('Arms', .47, '15%'),
];

const scheduleDaysDummyData = <ScheduleDay>[
  ScheduleDay(1, 'PUSH', ScheduleDayVariant.push),
  ScheduleDay(2, 'PULL', ScheduleDayVariant.pull),
  ScheduleDay(3, 'LEGS', ScheduleDayVariant.legs),
  ScheduleDay(4, null, ScheduleDayVariant.rest),
  ScheduleDay(5, 'UPPER', ScheduleDayVariant.upperOutline),
  ScheduleDay(6, 'PUSH', ScheduleDayVariant.push),
  ScheduleDay(7, null, ScheduleDayVariant.rest),
  ScheduleDay(8, 'PUSH', ScheduleDayVariant.push),
  ScheduleDay(9, 'PULL', ScheduleDayVariant.pull),
  ScheduleDay(10, 'LEGS', ScheduleDayVariant.legs),
  ScheduleDay(11, null, ScheduleDayVariant.rest),
  ScheduleDay(12, 'UPPER', ScheduleDayVariant.upperOutline),
  ScheduleDay(13, 'PUSH', ScheduleDayVariant.push),
  ScheduleDay(14, null, ScheduleDayVariant.rest),
  ScheduleDay(15, 'PUSH', ScheduleDayVariant.push),
  ScheduleDay(16, 'PULL', ScheduleDayVariant.pull),
  ScheduleDay(17, 'LEGS', ScheduleDayVariant.legs),
  ScheduleDay(18, null, ScheduleDayVariant.rest),
  ScheduleDay(19, 'UPPER', ScheduleDayVariant.upperMuted),
  ScheduleDay(20, 'PUSH', ScheduleDayVariant.push),
  ScheduleDay(21, null, ScheduleDayVariant.rest),
  ScheduleDay(22, 'PUSH', ScheduleDayVariant.push),
  ScheduleDay(23, 'PULL', ScheduleDayVariant.pull),
  ScheduleDay(24, 'LEGS', ScheduleDayVariant.legs),
  ScheduleDay(25, null, ScheduleDayVariant.rest),
  ScheduleDay(26, 'UPPER', ScheduleDayVariant.upperMuted),
  ScheduleDay(27, 'PUSH', ScheduleDayVariant.push),
  ScheduleDay(28, null, ScheduleDayVariant.rest),
  ScheduleDay(29, 'PUSH', ScheduleDayVariant.push),
  ScheduleDay(30, 'PULL', ScheduleDayVariant.pull),
];

const workoutProtocolsDummyData = <WorkoutProtocol>[
  WorkoutProtocol(
    title: 'Hypertrophy Matrix',
    category: 'Hypertrophy',
    difficulty: 'Intermediate',
    duration: '30 days',
    price: '\$49',
    expectedGain: '+2.4 kg',
    enrolledAthletes: 148,
    averageCompletion: .71,
    trainingDays: 22,
    stations: 9,
    totalSets: 228,
    coach: 'D. Raymond',
    sampleExercises: [
      ProtocolSampleExercise('Chest Press Machine', '4×8–10 · 185 lb'),
      ProtocolSampleExercise('Incline Smith Press', '3×10–12 · 135 lb'),
      ProtocolSampleExercise('Cable Fly Station', '3×12–15 · 45 lb'),
      ProtocolSampleExercise('Triceps Pushdown', '3×12–15 · 65 lb'),
    ],
  ),
  WorkoutProtocol(
    title: 'Strength & Peak Power',
    category: 'Strength',
    difficulty: 'Advanced',
    duration: '30 days',
    price: '\$59',
    expectedGain: '+18% 1RM',
    enrolledAthletes: 96,
    averageCompletion: .63,
    trainingDays: 22,
    stations: 9,
    totalSets: 228,
    coach: 'D. Raymond',
    sampleExercises: [
      ProtocolSampleExercise('Chest Press Machine', '4×6–8 · 205 lb'),
      ProtocolSampleExercise('Incline Smith Press', '4×6–8 · 155 lb'),
      ProtocolSampleExercise('Cable Fly Station', '3×10–12 · 55 lb'),
      ProtocolSampleExercise('Triceps Pushdown', '3×10–12 · 80 lb'),
    ],
  ),
  WorkoutProtocol(
    title: 'Lean Shred & Density',
    category: 'Conditioning',
    difficulty: 'All levels',
    duration: '30 days',
    price: '\$39',
    expectedGain: '−3% body fat',
    enrolledAthletes: 121,
    averageCompletion: .58,
    trainingDays: 22,
    stations: 9,
    totalSets: 228,
    coach: 'J. Okafor',
    sampleExercises: [
      ProtocolSampleExercise('Chest Press Machine', '4×8–10 · 185 lb'),
      ProtocolSampleExercise('Incline Smith Press', '3×10–12 · 135 lb'),
      ProtocolSampleExercise('Cable Fly Station', '3×12–15 · 45 lb'),
      ProtocolSampleExercise('Triceps Pushdown', '3×12–15 · 65 lb'),
    ],
  ),
];

const activeProtocolWeekDummyData = 2;
const activeProtocolTotalWeeksDummyData = 4;
