import 'dart:math';

class LeaderboardEntry {
  final int rank;
  final String name;
  final String tier;
  final int score;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.tier,
    required this.score,
    required this.isCurrentUser,
  });

  String get tierLabel => 'TIER $tier · ADMIN-AUDITED';
}

const _leaderboardAthletes = [
  ('Marcus V.', 12480, false),
  ('Elena K.', 11930, false),
  ('Dwayne O.', 9820, false),
  ('Priya S.', 8140, false),
  ('Alex (You)', 4300, true),
];

List<LeaderboardEntry> createLeaderboardDummyData({Random? random}) {
  const tiers = ['S', 'A', 'B', 'C'];
  final randomizer = random ?? Random();
  final emptyTierIndex = randomizer.nextInt(tiers.length);
  final activeTiers = [...tiers]..removeAt(emptyTierIndex);
  final assignments = [
    ...activeTiers,
    for (var i = activeTiers.length; i < _leaderboardAthletes.length; i++)
      activeTiers[randomizer.nextInt(activeTiers.length)],
  ]..shuffle(randomizer);

  return [
    for (var i = 0; i < _leaderboardAthletes.length; i++)
      LeaderboardEntry(
        rank: i + 1,
        name: _leaderboardAthletes[i].$1,
        tier: assignments[i],
        score: _leaderboardAthletes[i].$2,
        isCurrentUser: _leaderboardAthletes[i].$3,
      ),
  ];
}

final leaderboardDummyData = createLeaderboardDummyData();
