import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileAvatarProvider =
    NotifierProvider<ProfileAvatarNotifier, int>(ProfileAvatarNotifier.new);

class ProfileAvatarNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int value) => state = value;
}
