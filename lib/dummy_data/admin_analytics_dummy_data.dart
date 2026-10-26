class AdminMetricDummyData {
  final String value;
  final String label;

  const AdminMetricDummyData(this.value, this.label);
}

class AdminChartBarDummyData {
  final double height;
  final String label;

  const AdminChartBarDummyData(this.height, this.label);
}

class AdminProgressDummyData {
  final String label;
  final String value;
  final double progress;

  const AdminProgressDummyData(this.label, this.value, this.progress);
}

class AdminTrafficDummyData {
  final String day;
  final double progress;

  const AdminTrafficDummyData(this.day, this.progress);
}

class AdminPopularPlanDummyData {
  final String name;
  final String enrolled;
  final String completion;
  final String revenue;

  const AdminPopularPlanDummyData(
      this.name, this.enrolled, this.completion, this.revenue);
}

const adminRevenueMetricsDummyData = <AdminMetricDummyData>[
  AdminMetricDummyData('\$48,210', 'GROSS REVENUE'),
  AdminMetricDummyData('\$12.4k', 'MRR'),
  AdminMetricDummyData('\$149k', 'ARR'),
  AdminMetricDummyData('\$15', 'WALK-IN / DROP-IN FEE'),
];
const adminWalkInFeeHintDummyData = '15';

const adminRevenueSourcesDummyData = <AdminChartBarDummyData>[
  AdminChartBarDummyData(80, 'SUBSCRIPTIONS'),
  AdminChartBarDummyData(48, 'DROP-INS'),
  AdminChartBarDummyData(35, 'PLANS'),
  AdminChartBarDummyData(25, 'OTHER'),
];

const adminMembershipGrowthDummyData = <AdminChartBarDummyData>[
  AdminChartBarDummyData(45, 'MAR'),
  AdminChartBarDummyData(60, 'APR'),
  AdminChartBarDummyData(68, 'MAY'),
  AdminChartBarDummyData(76, 'JUN'),
  AdminChartBarDummyData(84, 'JUL'),
  AdminChartBarDummyData(92, 'AUG'),
];

const adminAthleteVerificationDummyData = <AdminProgressDummyData>[
  AdminProgressDummyData('VERIFIED', '3', .75),
  AdminProgressDummyData('UNVERIFIED', '2', .50),
];

const adminSquadEngagementDummyData =
    AdminProgressDummyData('IRON WOLVES', '342T', .82);
const adminGymCheckInsDummyData = 0;
const adminCurrentGymOccupancyDummyData = 0;

const adminWeeklyTrafficDummyData = <AdminTrafficDummyData>[
  AdminTrafficDummyData('MON', .72),
  AdminTrafficDummyData('TUE', .85),
  AdminTrafficDummyData('WED', .68),
  AdminTrafficDummyData('THU', .89),
  AdminTrafficDummyData('FRI', .76),
  AdminTrafficDummyData('SAT', .96),
  AdminTrafficDummyData('SUN', .58),
];

const adminPopularPlansDummyData = <AdminPopularPlanDummyData>[
  AdminPopularPlanDummyData('Hypertrophy Matrix', '148', '71%', '\$4,860'),
  AdminPopularPlanDummyData('Strength & Peak Power', '96', '63%', '\$3,420'),
  AdminPopularPlanDummyData('Lean Shred & Density', '121', '58%', '\$2,910'),
];
