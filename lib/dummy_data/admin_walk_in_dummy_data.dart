import 'package:pump_gym/dummy_data/admin_athletes_dummy_data.dart';

const adminGymNameDummyData = 'PUMP GYM';
const adminGymEntranceDummyData = 'Main Entrance';

class AdminWalkInRecord {
  final String id;
  final String name;
  final String username;
  final DateTime checkedInAt;
  final String source;
  final bool oneTimeVisitor;
  final DateTime? checkedOutAt;

  const AdminWalkInRecord({
    required this.id,
    required this.name,
    required this.username,
    required this.checkedInAt,
    required this.source,
    required this.oneTimeVisitor,
    this.checkedOutAt,
  });

  AdminWalkInRecord checkOut(DateTime time) => AdminWalkInRecord(
        id: id,
        name: name,
        username: username,
        checkedInAt: checkedInAt,
        source: source,
        oneTimeVisitor: oneTimeVisitor,
        checkedOutAt: time,
      );
}

List<AdminWalkInRecord> adminWalkInRecordsDummyData(DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  DateTime at(int daysAgo, int hour, int minute) => DateTime(
        today.year,
        today.month,
        today.day - daysAgo,
        hour,
        minute,
      );

  return [
    AdminWalkInRecord(
      id: 'visitor-abdo-${today.toIso8601String()}',
      name: 'abdo',
      username: '',
      checkedInAt: at(0, 15, 6),
      source: 'WALK-IN',
      oneTimeVisitor: true,
    ),
    AdminWalkInRecord(
      id: 'athlete-tom-${today.toIso8601String()}',
      name: 'Tom H.',
      username: '@TOM.H',
      checkedInAt: at(0, 15, 5),
      source: 'ADMIN SCAN',
      oneTimeVisitor: false,
    ),
    AdminWalkInRecord(
      id: 'athlete-marcus-${today.toIso8601String()}',
      name: 'Marcus V.',
      username: '@MARCUS.V',
      checkedInAt: at(0, 15, 3),
      source: 'ADMIN SCAN',
      oneTimeVisitor: false,
    ),
    AdminWalkInRecord(
      id: 'athlete-elena-${today.toIso8601String()}',
      name: 'Elena K.',
      username: '@ELENA.K',
      checkedInAt: at(1, 17, 55),
      source: 'ADMIN SCAN',
      oneTimeVisitor: false,
      checkedOutAt: at(1, 19, 2),
    ),
    AdminWalkInRecord(
      id: 'athlete-alex-${today.toIso8601String()}',
      name: 'Alex Carter',
      username: '@ALEX.CARTER',
      checkedInAt: at(3, 6, 42),
      source: 'ADMIN SCAN',
      oneTimeVisitor: false,
      checkedOutAt: at(3, 7, 51),
    ),
  ];
}

String adminAthleteUsernameDummyData(AdminAthleteDummyData athlete) {
  final match = RegExp(r'@[\w.]+').firstMatch(athlete.detail);
  return match?.group(0) ??
      '@${athlete.name.toUpperCase().replaceAll(' ', '.')}';
}
