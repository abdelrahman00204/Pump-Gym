import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pump_gym/admin_shell.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/dummy_data/gym_group_dummy_data.dart';
import 'package:pump_gym/widgets/admin_top_bar.dart';

class AdminGroupsScreen extends StatelessWidget {
  const AdminGroupsScreen({super.key});

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
                for (final group in gymGroupsDummyData)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRIVATE GROUPS — FULL MEMBER & GOAL DETAILS'.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 1.5,
                            height: 2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      group.name,
                                      style: const TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      'CODE: {code}'.tr(
                                        namedArgs: {'code': group.code},
                                      ),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        fontSize: 10,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'GOAL: {goal}'.tr(
                                        namedArgs: {'goal': group.goal},
                                      ),
                                      style: const TextStyle(
                                        letterSpacing: 1.5,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '{count} MEMBERS'.tr(
                                      namedArgs: {
                                        'count': '${group.memberCount}',
                                      },
                                    ),
                                    style: const TextStyle(
                                      letterSpacing: 1.5,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: group.progress,
                                  minHeight: 9,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.outline,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 18),
                              for (final member in group.members)
                                _Member(
                                  name: member.name,
                                  tonnage: member.tonnage,
                                ),
                            ],
                          ),
                        ),
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

class _Member extends StatelessWidget {
  final String name;
  final String tonnage;

  const _Member({
    required this.name,
    required this.tonnage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(name)),
          Text(
            tonnage,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
