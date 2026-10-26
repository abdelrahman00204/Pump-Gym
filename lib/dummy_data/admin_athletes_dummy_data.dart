class AdminAthleteDummyData {
  final String name;
  final String detail;
  final bool verified;
  final bool delinquent;
  final String membership;
  final String joined;
  final String renews;
  final int sessionsUsedThisMonth;
  final int monthlySessionLimit;
  final List<AdminAthleteVisitDummyData> visits;

  const AdminAthleteDummyData({
    required this.name,
    required this.detail,
    required this.verified,
    this.delinquent = false,
    this.membership = 'Unlimited',
    this.joined = '2026-06-01',
    this.renews = '2026-11-01',
    this.sessionsUsedThisMonth = 2,
    this.monthlySessionLimit = 12,
    this.visits = const [],
  });
}

class AdminAthleteVisitDummyData {
  final DateTime date;
  final String checkIn;
  final String checkOut;

  const AdminAthleteVisitDummyData({
    required this.date,
    required this.checkIn,
    required this.checkOut,
  });
}

final adminAthletesDummyData = <AdminAthleteDummyData>[
  AdminAthleteDummyData(
    name: 'Alex Carter',
    detail: 'TIER A · COACH D. RAYMOND · @ALEX.CARTER',
    verified: true,
    membership: 'Unlimited',
    joined: '2026-03-12',
    renews: '2026-11-12',
    sessionsUsedThisMonth: 8,
    monthlySessionLimit: 12,
    visits: [
      AdminAthleteVisitDummyData(
        date: DateTime(2026, 10, 20),
        checkIn: '06:42',
        checkOut: '07:51',
      ),
      AdminAthleteVisitDummyData(
        date: DateTime(2026, 10, 16),
        checkIn: '06:38',
        checkOut: '07:45',
      ),
      AdminAthleteVisitDummyData(
        date: DateTime(2026, 9, 29),
        checkIn: '18:10',
        checkOut: '19:22',
      ),
    ],
  ),
  AdminAthleteDummyData(
    name: 'Marcus V.',
    detail: 'TIER S · COACH D. RAYMOND · @MARCUS.V',
    verified: true,
    delinquent: true,
    membership: '12-Session Pack',
    joined: '2026-01-16',
    renews: '2026-10-28',
    sessionsUsedThisMonth: 2,
    monthlySessionLimit: 12,
    visits: [
      AdminAthleteVisitDummyData(
        date: DateTime(2026, 10, 13),
        checkIn: '19:26',
        checkOut: '20:14',
      ),
      AdminAthleteVisitDummyData(
        date: DateTime(2026, 9, 22),
        checkIn: '18:40',
        checkOut: '19:35',
      ),
    ],
  ),
  AdminAthleteDummyData(
    name: 'Elena K.',
    detail: 'TIER S · COACH J. OKAFOR · @ELENA.K',
    verified: true,
    delinquent: true,
    membership: '12-Session Pack',
    joined: '2026-06-01',
    renews: '2026-09-01',
    sessionsUsedThisMonth: 2,
    monthlySessionLimit: 12,
    visits: [
      AdminAthleteVisitDummyData(
        date: DateTime(2026, 10, 13),
        checkIn: '19:26',
        checkOut: '20:14',
      ),
      AdminAthleteVisitDummyData(
        date: DateTime(2026, 10, 14),
        checkIn: '17:55',
        checkOut: '19:02',
      ),
      AdminAthleteVisitDummyData(
        date: DateTime(2026, 9, 22),
        checkIn: '18:40',
        checkOut: '19:35',
      ),
    ],
  ),
  AdminAthleteDummyData(
    name: 'Tom H.',
    detail: 'TIER B · COACH J. OKAFOR · @TOM.H',
    verified: false,
    membership: 'Unlimited',
    joined: '2026-05-07',
    renews: '2026-11-07',
    visits: [
      AdminAthleteVisitDummyData(
        date: DateTime(2026, 10, 18),
        checkIn: '09:05',
        checkOut: '10:10',
      ),
    ],
  ),
  const AdminAthleteDummyData(
    name: 'Yuki M.',
    detail: 'TIER B · COACH D. RAYMOND · @YUKI.M',
    verified: false,
    delinquent: true,
    membership: '8-Session Pack',
    joined: '2026-04-20',
    renews: '2026-10-20',
    sessionsUsedThisMonth: 0,
    monthlySessionLimit: 8,
  ),
];
