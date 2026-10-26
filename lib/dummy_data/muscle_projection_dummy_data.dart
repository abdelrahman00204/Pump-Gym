class MuscleProjection {
  final String name;
  final double value;

  const MuscleProjection(this.name, this.value);
}

const muscleGroupsDummyData = [
  'All',
  'Chest',
  'Legs',
  'Back',
  'Shoulders',
  'Arms',
];

const musclesByGroupDummyData = <String, List<MuscleProjection>>{
  'All': [
    MuscleProjection('Chest', 0.86),
    MuscleProjection('Shoulders', 0.64),
    MuscleProjection('Arms', 0.48),
    MuscleProjection('Back', 0.76),
    MuscleProjection('Legs', 0.90),
  ],
  'Chest': [
    MuscleProjection('Chest', 0.86),
    MuscleProjection('Triceps', 0.52),
  ],
  'Legs': [
    MuscleProjection('Quads', 0.90),
    MuscleProjection('Glutes', 0.74),
    MuscleProjection('Calves', 0.40),
  ],
  'Back': [
    MuscleProjection('Lats', 0.78),
    MuscleProjection('Traps', 0.55),
    MuscleProjection('Biceps', 0.44),
  ],
  'Shoulders': [
    MuscleProjection('Front delts', 0.69),
    MuscleProjection('Side delts', 0.61),
  ],
  'Arms': [
    MuscleProjection('Biceps', 0.72),
    MuscleProjection('Triceps', 0.65),
    MuscleProjection('Forearms', 0.38),
  ],
};
