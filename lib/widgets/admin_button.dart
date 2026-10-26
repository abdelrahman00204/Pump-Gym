import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pump_gym/constants/app_routes.dart';
import 'package:pump_gym/widgets/top_bar.dart';

class AdminButton extends StatelessWidget {
  const AdminButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.adminAccess),
      child: const IconPill(
        icon: Icons.shield_outlined,
      ),
    );
  }
}
