import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/constants/app_routes.dart';
import 'package:pump_gym/features/providers/admin_access_screen_provider.dart';

class AdminAccessScreen extends ConsumerStatefulWidget {
  const AdminAccessScreen({super.key});

  @override
  ConsumerState<AdminAccessScreen> createState() => _AdminAccessScreenState();
}

class _AdminAccessScreenState extends ConsumerState<AdminAccessScreen> {
  final _passcodeController = TextEditingController();

  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  void _continue() {
    final passcode = _passcodeController.text.trim();

    if (passcode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the admin passcode.'.tr()),
        ),
      );
      return;
    }

    // TODO:
    // Validate the passcode through the backend/auth system.
    //
    // Do NOT hardcode the real admin passcode here.
    //
    // Once authentication is implemented:
    context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final obscurePasscode = ref.watch(adminPasscodeObscuredProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Admin Access'.tr()),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 56,
                ),
                const SizedBox(height: 24),
                Text(
                  'Admin Access'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the admin passcode to continue.'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _passcodeController,
                  obscureText: obscurePasscode,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _continue(),
                  decoration: InputDecoration(
                    labelText: 'Admin passcode'.tr(),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => ref
                          .read(adminPasscodeObscuredProvider.notifier)
                          .toggle(),
                      icon: Icon(
                        obscurePasscode
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _continue,
                    child: Text('Continue'.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
