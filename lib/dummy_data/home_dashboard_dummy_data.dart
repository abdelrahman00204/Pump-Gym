class HomeExerciseDummyData {
  final String name;
  final String detail;
  final String pin;

  const HomeExerciseDummyData({
    required this.name,
    required this.detail,
    required this.pin,
  });
}

class HomeVolumeWeekDummyData {
  final String label;
  final double progress;
  final String percentage;

  const HomeVolumeWeekDummyData({
    required this.label,
    required this.progress,
    required this.percentage,
  });
}

const homeDashboardTierDummyData = 'TIER A · LVL 6';
const homeDashboardProgramDummyData = 'Hypertrophy Matrix';
const homeDashboardPowerPointsDummyData = '2,700';
const homeDashboardCoachProgressDummyData =
    'Coach: D. Raymond · Progressive Overload W2';
const homeDashboardGymOccupancyDummyData = 1;
const homeDashboardProtocolCompletionDummyData = 0.4;
const homeDashboardQrUserIdDummyData = '1';
const homeDashboardQrUsernameDummyData = 'Alex';
const homeDashboardWeekLabelDummyData = 'Push · Week 13';

const homeExercisesDummyData = <HomeExerciseDummyData>[
  HomeExerciseDummyData(
    name: 'Chest Press Machine',
    detail: '4 sets · 8–10 reps · 185 lbs',
    pin: 'Seat pin 6',
  ),
  HomeExerciseDummyData(
    name: 'Incline Smith Press',
    detail: '3 sets · 10–12 reps · 135 lbs',
    pin: 'Seat pin 4',
  ),
  HomeExerciseDummyData(
    name: 'Cable Fly Station',
    detail: '3 sets · 12–15 reps · 45 lbs',
    pin: 'Seat pin 9',
  ),
  HomeExerciseDummyData(
    name: 'Triceps Pushdown',
    detail: '3 sets · 12–15 reps · 65 lbs',
    pin: 'Seat pin 11',
  ),
];

const homeVolumeWeeksDummyData = <HomeVolumeWeekDummyData>[
  HomeVolumeWeekDummyData(
      label: 'W1 Foundation', progress: 1, percentage: '100%'),
  HomeVolumeWeekDummyData(
      label: 'W2 Overload', progress: .72, percentage: '72%'),
  HomeVolumeWeekDummyData(
      label: 'W3 Intensification', progress: .3, percentage: '30%'),
  HomeVolumeWeekDummyData(label: 'W4 Peak', progress: .05, percentage: '5%'),
];

const homeVolumeTrajectoryDummyData = <double>[
  .28,
  .82,
  .66,
  .43,
  .25,
  .86,
  .61,
  .48,
  .32,
  .90,
  .72,
  .52,
  .36,
  .78,
  .58,
  .42,
  .94,
  .68,
  .51,
  .31,
  .85,
  .65,
  .46,
  .29,
  .88,
  .70,
  .49,
  .76,
];
const homeVolumeCompletedDaysDummyData = 12;
