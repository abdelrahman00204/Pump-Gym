class GymGroupMemberDummyData {
  final String name;
  final String tonnage;

  const GymGroupMemberDummyData(this.name, this.tonnage);
}

class GymGroupDummyData {
  final String name;
  final String code;
  final String goal;
  final int memberCount;
  final double progress;
  final List<GymGroupMemberDummyData> members;

  const GymGroupDummyData({
    required this.name,
    required this.code,
    required this.goal,
    required this.memberCount,
    required this.progress,
    required this.members,
  });
}

const gymGroupsDummyData = <GymGroupDummyData>[
  GymGroupDummyData(
    name: 'Iron Wolves',
    code: 'WOLF-42',
    goal: '500T/MO',
    memberCount: 5,
    progress: .88,
    members: [
      GymGroupMemberDummyData('Marcus V. @marcus.v', '96T'),
      GymGroupMemberDummyData('Elena K. @elena.k', '81T'),
      GymGroupMemberDummyData('Alex (You) @alex.carter', '62T'),
      GymGroupMemberDummyData('Tom H. @tom.h', '54T'),
      GymGroupMemberDummyData('Priya S. @priya.s', '49T'),
    ],
  ),
];
