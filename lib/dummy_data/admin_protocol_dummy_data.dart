class AdminProtocolExercise {
  final String machine;
  final String sets;
  final String reps;
  final String weight;
  final String restSeconds;

  const AdminProtocolExercise({
    required this.machine,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.restSeconds,
  });
}

class AdminProtocolDay {
  final String label;
  final String intensity;
  final List<AdminProtocolExercise> exercises;

  const AdminProtocolDay({
    required this.label,
    required this.intensity,
    required this.exercises,
  });
}

class AdminProtocol {
  final String id;
  final String title;
  final String coach;
  final String category;
  final String price;
  final String difficulty;
  final String expectedGain;
  final int durationDays;
  final List<AdminProtocolDay> days;

  const AdminProtocol({
    required this.id,
    required this.title,
    required this.coach,
    required this.category,
    required this.price,
    required this.difficulty,
    required this.expectedGain,
    required this.durationDays,
    required this.days,
  });
}

const adminProtocolCategoriesDummyData = <String>[
  'Hypertrophy',
  'Strength',
  'Conditioning',
  'General Fitness',
];

const adminProtocolDifficultiesDummyData = <String>[
  'Beginner',
  'Intermediate',
  'Advanced',
  'All levels',
];

const adminProtocolIntensitiesDummyData = <String>[
  'Push',
  'Pull',
  'Legs',
  'Upper',
  'Rest',
];

const adminProtocolMachinesDummyData = <String>[
  'Chest Press Machine',
  'Incline Smith Press',
  'Cable Fly Station',
  'Triceps Pushdown',
  'Lat Pulldown',
  'Seated Cable Row',
  'Leg Press',
  'Leg Curl Machine',
  'Dumbbell Rack',
  'Treadmill',
];

const _samplePushExercises = <AdminProtocolExercise>[
  AdminProtocolExercise(
    machine: 'Chest Press Machine',
    sets: '4',
    reps: '8–10',
    weight: '185',
    restSeconds: '90',
  ),
  AdminProtocolExercise(
    machine: 'Incline Smith Press',
    sets: '3',
    reps: '10–12',
    weight: '135',
    restSeconds: '90',
  ),
  AdminProtocolExercise(
    machine: 'Cable Fly Station',
    sets: '3',
    reps: '12–15',
    weight: '45',
    restSeconds: '60',
  ),
  AdminProtocolExercise(
    machine: 'Triceps Pushdown',
    sets: '3',
    reps: '12–15',
    weight: '65',
    restSeconds: '60',
  ),
];

List<AdminProtocolDay> _sampleDays() {
  const workoutTypes = [
    'Push',
    'Pull',
    'Legs',
    'Rest',
    'Upper',
    'Rest',
    'Rest'
  ];
  return List.generate(30, (index) {
    final intensity = workoutTypes[index % workoutTypes.length];
    return AdminProtocolDay(
      label: intensity == 'Rest' ? 'Rest Day' : '$intensity Day',
      intensity: intensity,
      exercises: intensity == 'Rest' || intensity == 'Push'
          ? (intensity == 'Push' ? _samplePushExercises : const [])
          : _samplePushExercises,
    );
  });
}

final adminProtocolDefaultDaysDummyData = _sampleDays();

final adminProtocolsDummyData = <AdminProtocol>[
  AdminProtocol(
    id: 'hypertrophy-matrix',
    title: 'Hypertrophy Matrix',
    coach: 'D. Raymond',
    category: 'Hypertrophy',
    price: '49',
    difficulty: 'Intermediate',
    expectedGain: '+2.4 KG',
    durationDays: 30,
    days: _sampleDays(),
  ),
  AdminProtocol(
    id: 'strength-peak-power',
    title: 'Strength & Peak Power',
    coach: 'D. Raymond',
    category: 'Strength',
    price: '59',
    difficulty: 'Advanced',
    expectedGain: '+18% 1RM',
    durationDays: 30,
    days: _sampleDays(),
  ),
  AdminProtocol(
    id: 'lean-shred-density',
    title: 'Lean Shred & Density',
    coach: 'J. Okafor',
    category: 'Conditioning',
    price: '39',
    difficulty: 'All levels',
    expectedGain: '−3% body fat',
    durationDays: 30,
    days: _sampleDays(),
  ),
];
