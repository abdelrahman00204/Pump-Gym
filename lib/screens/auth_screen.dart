import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:pump_gym/constants/app_routes.dart';
import 'package:pump_gym/widgets/admin_button.dart';
import 'package:pump_gym/features/providers/auth_screen_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validation only happens when the user presses Sign In.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref.read(authLoadingProvider.notifier).setLoading(true);

    try {
      /*
      // REAL LOGIN:
      //
      // When the backend is ready, replace the temporary navigation
      // below with:
      //
      // await ref.read(authProvider.notifier).login(
      //   _usernameController.text.trim(),
      //   _passwordController.text,
      // );
      */

      // Temporary navigation while authentication is being developed.
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        context.go(AppRoutes.lobby);
      }
    } finally {
      if (mounted) ref.read(authLoadingProvider.notifier).setLoading(false);
    }
  }

  String? _validateUsernameOrEmail(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please enter your username or email'.tr();
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password'.tr();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: 50,
            right: 30,
            child: AdminButton(),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'PUMP GYM OS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _usernameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Username or Email'.tr(),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: _validateUsernameOrEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        decoration: InputDecoration(
                          labelText: 'Password'.tr(),
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(),
                                )
                              : Text('Sign In'.tr()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          context.push(AppRoutes.signUp);
                        },
                        child: Text(
                          "Don't have an account? Sign Up".tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
