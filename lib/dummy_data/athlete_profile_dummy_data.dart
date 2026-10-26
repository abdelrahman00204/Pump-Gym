class AthleteProfileDummyData {
  final String name;
  final String username;
  final String rank;
  final String bio;
  final String weightKg;
  final String heightCm;
  final String dailyCalories;
  final String dailyWaterLiters;
  final String tier;
  final int level;
  final int experiencePoints;

  const AthleteProfileDummyData({
    required this.name,
    required this.username,
    required this.rank,
    required this.bio,
    required this.weightKg,
    required this.heightCm,
    required this.dailyCalories,
    required this.dailyWaterLiters,
    required this.tier,
    required this.level,
    required this.experiencePoints,
  });
}

const athleteProfileDummyData = AthleteProfileDummyData(
  name: 'Alex Carter',
  username: 'alex.carter',
  rank: 'Iron Contender',
  bio: 'Chasing 315 bench',
  weightKg: '84',
  heightCm: '182',
  dailyCalories: '3100',
  dailyWaterLiters: '3.5',
  tier: 'A',
  level: 7,
  experiencePoints: 3275,
);
