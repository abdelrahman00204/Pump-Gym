import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpLoadingProvider =
    NotifierProvider<SignUpLoadingNotifier, bool>(SignUpLoadingNotifier.new);

class SignUpLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoading(bool value) => state = value;
}

final signUpVisibilityProvider =
    NotifierProvider<SignUpVisibilityNotifier, SignUpVisibility>(
  SignUpVisibilityNotifier.new,
);

class SignUpVisibility {
  final bool password;
  final bool confirmPassword;

  const SignUpVisibility({this.password = true, this.confirmPassword = true});

  SignUpVisibility copyWith({bool? password, bool? confirmPassword}) =>
      SignUpVisibility(
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
      );
}

class SignUpVisibilityNotifier extends Notifier<SignUpVisibility> {
  @override
  SignUpVisibility build() => const SignUpVisibility();

  void togglePassword() => state = state.copyWith(password: !state.password);

  void toggleConfirmPassword() =>
      state = state.copyWith(confirmPassword: !state.confirmPassword);
}
