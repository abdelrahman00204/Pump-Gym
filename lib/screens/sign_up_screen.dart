import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/features/providers/sign_up_screen_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Email validation regex.
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@'
    r'[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}'
    r'[a-zA-Z0-9])?(?:\.[a-zA-Z0-9]'
    r'(?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
  );

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // Validation only happens when Sign Up is pressed.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref.read(signUpLoadingProvider.notifier).setLoading(true);

    try {
      /*
      // REAL SIGN UP:
      //
      // When the backend is ready, send:
      //
      // fullName
      // username
      // email
      // password
      //
      // to the registration endpoint.
      */

      // Temporary navigation while authentication is being developed.
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account information is valid.'.tr()),
          ),
        );
      }
    } finally {
      if (mounted) ref.read(signUpLoadingProvider.notifier).setLoading(false);
    }
  }

  String? _validateFullName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please enter your full name'.tr();
    }

    if (text.length < 3) {
      return 'Full name must be at least 3 characters'.tr();
    }

    return null;
  }

  String? _validateUsername(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please enter a username'.tr();
    }

    if (text.length < 3) {
      return 'Username must be at least 3 characters'.tr();
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(text)) {
      return 'Username can only contain letters, numbers and _'.tr();
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please enter your email'.tr();
    }

    if (!_emailRegex.hasMatch(text)) {
      return 'Please enter a valid email address'.tr();
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password'.tr();
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters'.tr();
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password'.tr();
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match'.tr();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(signUpLoadingProvider);
    final visibility = ref.watch(signUpVisibilityProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Create Account'.tr()),
      ),
      body: Center(
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
                  Text(
                    'JOIN PUMP'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your gym account'.tr(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _fullNameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Full Name'.tr(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: _validateFullName,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Username'.tr(),
                      prefixIcon: const Icon(Icons.alternate_email),
                    ),
                    validator: _validateUsername,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email'.tr(),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: visibility.password,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Password'.tr(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => ref
                            .read(signUpVisibilityProvider.notifier)
                            .togglePassword(),
                        icon: Icon(
                          visibility.password
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: visibility.confirmPassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleSignUp(),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password'.tr(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => ref
                            .read(signUpVisibilityProvider.notifier)
                            .toggleConfirmPassword(),
                        icon: Icon(
                          visibility.confirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: _validateConfirmPassword,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleSignUp,
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(),
                            )
                          : Text('Create Account'.tr()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      'Already have an account? Sign In'.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
