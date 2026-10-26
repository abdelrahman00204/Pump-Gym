import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaderboardMainTabProvider =
    NotifierProvider<LeaderboardMainTabNotifier, int>(
  LeaderboardMainTabNotifier.new,
);
final leaderboardTierFilterProvider =
    NotifierProvider<LeaderboardTierFilterNotifier, int>(
  LeaderboardTierFilterNotifier.new,
);
final leaderboardTimeFilterProvider =
    NotifierProvider<LeaderboardTimeFilterNotifier, int>(
  LeaderboardTimeFilterNotifier.new,
);

class LeaderboardMainTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int value) => state = value;
}

class LeaderboardTierFilterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int value) => state = value;
}

class LeaderboardTimeFilterNotifier extends Notifier<int> {
  @override
  int build() => 1;

  void select(int value) => state = value;
}
