import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pump_gym/admin_shell.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/dummy_data/admin_athletes_dummy_data.dart';
import 'package:pump_gym/widgets/admin_athlete_card.dart';
import 'package:pump_gym/widgets/admin_top_bar.dart';
import 'package:pump_gym/wide_layout.dart';

class AdminAthletesScreen extends StatelessWidget {
  const AdminAthletesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      body: Column(
        children: [
          if (!showsDesktopTopNav(context)) const AdminTopBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              children: [
                Text(
                  'ADMIN HQ CONSOLE'.tr(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 28),
                _Section(
                  title:
                      'ATHLETES ROSTER — ASSIGN PLANS & VERIFY FOR GLOBAL RANK'
                          .tr(),
                  child: PumpCardGrid(
                    compact: 1,
                    medium: 1,
                    expanded: 3,
                    spacing: 0,
                    children: [
                      for (final athlete in adminAthletesDummyData)
                        AdminAthleteCard(athlete: athlete),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1.5,
              height: 2,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
