import 'package:flutter/material.dart';

class MachineItem {
  final String name;
  final String category;
  final String lastWeight;
  final String prWeight;
  final IconData icon;
  final List<String> searchTerms;
  final List<String> executionSteps;
  final String safety;
  final List<String> alternatives;
  final int targetSets;

  const MachineItem({
    required this.name,
    required this.category,
    required this.lastWeight,
    required this.prWeight,
    required this.icon,
    this.searchTerms = const [],
    this.executionSteps = const [],
    this.safety = 'Use a controlled range of motion and stop if you feel pain.',
    this.alternatives = const [],
    this.targetSets = 4,
  });

  String get primaryMuscle => category.split('·').first.trim();
  int get startingWeight =>
      int.tryParse(lastWeight.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
}

const machineFiltersDummyData = [
  'All',
  'Chest',
  'Legs',
  'Back',
  'Shoulders',
  'Arms',
  'Cardio',
];

const machineCatalogDummyData = <MachineItem>[
  MachineItem(
    name: 'Chest Press Machine',
    category: 'CHEST · STRENGTH',
    lastWeight: '185 LB',
    prWeight: 'PR 205',
    icon: Icons.fitness_center,
    searchTerms: ['pectorals', 'triceps', 'front delts', 'push'],
    executionSteps: [
      'Set the seat so handles align with mid-chest.',
      'Brace your core and keep feet flat on the floor.',
      'Press smoothly; control the return to the start.',
    ],
    safety: 'Keep shoulder blades retracted; avoid bouncing at end range.',
    alternatives: ['Smith Press', 'Dumbbell Press', 'Pec Deck'],
  ),
  MachineItem(
    name: 'Incline Smith Press',
    category: 'CHEST · STRENGTH',
    lastWeight: '135 LB',
    prWeight: 'PR 155',
    icon: Icons.fitness_center,
    searchTerms: ['upper chest', 'pectorals', 'shoulders', 'push'],
    executionSteps: [
      'Set the bench to a low incline under the bar.',
      'Unrack with wrists stacked over elbows.',
      'Lower to upper chest and press without locking hard.',
    ],
    safety: 'Set the safety stops before loading the bar.',
    alternatives: ['Chest Press Machine', 'Incline Dumbbell Press'],
  ),
  MachineItem(
    name: 'Cable Fly Station',
    category: 'CHEST · ISOLATION',
    lastWeight: '45 LB',
    prWeight: 'PR 55',
    icon: Icons.cable,
    searchTerms: ['pectorals', 'chest', 'fly'],
    executionSteps: [
      'Set pulleys around shoulder height and take a split stance.',
      'Keep a soft bend in the elbows throughout.',
      'Bring handles together slowly and return with control.',
    ],
    safety: 'Use a comfortable stretch; do not force the shoulder behind you.',
    alternatives: ['Pec Deck', 'Dumbbell Fly'],
  ),
  MachineItem(
    name: 'Leg Press',
    category: 'LEGS · STRENGTH',
    lastWeight: '360 LB',
    prWeight: 'PR 405',
    icon: Icons.airline_seat_legroom_extra,
    searchTerms: ['quads', 'glutes', 'hamstrings', 'lower body'],
    executionSteps: [
      'Place feet shoulder-width apart on the platform.',
      'Lower until knees reach a comfortable depth.',
      'Drive through the whole foot without locking knees.',
    ],
    safety: 'Keep hips against the pad and knees tracking over toes.',
    alternatives: ['Goblet Squat', 'Hack Squat'],
  ),
  MachineItem(
    name: 'Lat Pulldown',
    category: 'BACK · STRENGTH',
    lastWeight: '150 LB',
    prWeight: 'PR 170',
    icon: Icons.arrow_downward,
    searchTerms: ['lats', 'biceps', 'pull'],
    executionSteps: [
      'Set thigh pads snugly and take a wide overhand grip.',
      'Lean back slightly and pull the bar to upper chest.',
      'Return overhead slowly without shrugging.',
    ],
    safety: 'Pull in front of the head and keep the movement controlled.',
    alternatives: ['Assisted Pull-up', 'Straight-arm Pulldown'],
  ),
  MachineItem(
    name: 'Seated Cable Row',
    category: 'BACK · STRENGTH',
    lastWeight: '140 LB',
    prWeight: 'PR 160',
    icon: Icons.rowing,
    searchTerms: ['back', 'lats', 'rhomboids', 'biceps', 'pull'],
    executionSteps: [
      'Sit tall with a soft bend in the knees.',
      'Pull the handle toward your lower ribs.',
      'Extend arms slowly while keeping your torso steady.',
    ],
    safety: 'Avoid rocking your torso to move the weight.',
    alternatives: ['Dumbbell Row', 'Chest-supported Row'],
  ),
  MachineItem(
    name: 'Shoulder Press Machine',
    category: 'SHOULDERS · STRENGTH',
    lastWeight: '110 LB',
    prWeight: 'PR 125',
    icon: Icons.accessibility_new,
    searchTerms: ['deltoids', 'triceps', 'overhead press'],
    executionSteps: [
      'Adjust the seat so handles begin near shoulder height.',
      'Keep your back supported and press overhead.',
      'Lower with control to the starting position.',
    ],
    safety: 'Use a pain-free range and keep your back against the pad.',
    alternatives: ['Dumbbell Shoulder Press', 'Landmine Press'],
  ),
  MachineItem(
    name: 'Triceps Pushdown',
    category: 'ARMS · ISOLATION',
    lastWeight: '65 LB',
    prWeight: 'PR 80',
    icon: Icons.fitness_center,
    searchTerms: ['triceps', 'arms', 'push'],
    executionSteps: [
      'Stand tall and keep elbows close to your sides.',
      'Extend the elbows to move the bar down.',
      'Return until forearms are just above parallel.',
    ],
    safety:
        'Keep shoulders relaxed and avoid leaning your body weight into it.',
    alternatives: ['Overhead Cable Extension', 'Close-grip Push-up'],
  ),
  MachineItem(
    name: 'Bicep Curl Machine',
    category: 'ARMS · ISOLATION',
    lastWeight: '55 LB',
    prWeight: 'PR 70',
    icon: Icons.fitness_center,
    searchTerms: ['biceps', 'arms', 'curl'],
    executionSteps: [
      'Align elbows with the machine pivot and grip the handles.',
      'Curl upward without lifting your upper arms.',
      'Lower slowly until elbows are nearly straight.',
    ],
    safety: 'Keep wrists neutral and avoid swinging the weight.',
    alternatives: ['Cable Curl', 'Dumbbell Curl'],
  ),
  MachineItem(
    name: 'Treadmill Pro X',
    category: 'CARDIO · CARDIO',
    lastWeight: '—',
    prWeight: '—',
    icon: Icons.directions_run,
    searchTerms: ['running', 'walking', 'conditioning'],
    executionSteps: [
      'Clip the safety key to your clothing before starting.',
      'Begin at a comfortable walking pace.',
      'Increase speed or incline gradually as needed.',
    ],
    safety: 'Step onto the side rails before starting or stopping the belt.',
    alternatives: ['Stationary Bike', 'Elliptical'],
  ),
];
