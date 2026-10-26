import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminPasscodeObscuredProvider =
    NotifierProvider<AdminPasscodeVisibilityNotifier, bool>(
  AdminPasscodeVisibilityNotifier.new,
);

class AdminPasscodeVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}
