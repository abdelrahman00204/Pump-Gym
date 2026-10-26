import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pump_gym/dummy_data/admin_analytics_dummy_data.dart';
import 'package:pump_gym/admin_shell.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/theme/pump_theme.dart';
import 'package:pump_gym/widgets/admin_top_bar.dart';
import 'package:pump_gym/wide_layout.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminAnalyticsView();
  }
}

class AdminAnalyticsView extends StatelessWidget {
  const AdminAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      body: Column(
        children: [
          if (!showsDesktopTopNav(context)) const AdminTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ADMIN HQ CONSOLE'.tr(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PumpColumns(
                    main: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PumpCardGrid(
                            compact: 2,
                            medium: 2,
                            expanded: 4,
                            spacing: PumpSpacing.md,
                            children: [
                              for (final metric in adminRevenueMetricsDummyData)
                                _MetricCard(
                                  value: metric.value,
                                  label: metric.label,
                                ),
                            ],
                          ),
                          const SizedBox(height: PumpSpacing.xs),
                          _SectionCard(
                            title: 'REVENUE DISTRIBUTION'.tr(),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (final bar in adminRevenueSourcesDummyData)
                                  _Bar(height: bar.height, label: bar.label),
                              ],
                            ),
                          ),
                          const SizedBox(height: PumpSpacing.md),
                          _SectionCard(
                            title: 'MEMBERSHIP GROWTH ({count} MONTHS)'.tr(
                              namedArgs: {
                                'count':
                                    '${adminMembershipGrowthDummyData.length}',
                              },
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (final month
                                    in adminMembershipGrowthDummyData)
                                  _GrowthBar(
                                    height: month.height,
                                    month: month.label,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: PumpSpacing.md),
                          _SectionCard(
                            title: 'ATHLETE VERIFICATION STATUS'.tr(),
                            child: Column(
                              children: [
                                for (var i = 0;
                                    i <
                                        adminAthleteVerificationDummyData
                                            .length;
                                    i++) ...[
                                  _ProgressRow(
                                    label: adminAthleteVerificationDummyData[i]
                                        .label,
                                    value: adminAthleteVerificationDummyData[i]
                                        .value,
                                    progress:
                                        adminAthleteVerificationDummyData[i]
                                            .progress,
                                  ),
                                  if (i <
                                      adminAthleteVerificationDummyData.length -
                                          1)
                                    const SizedBox(height: 12),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    side: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SectionCard(
                            title: 'SQUAD ENGAGEMENT (TONNAGE / SQUAD)'.tr(),
                            child: _ProgressRow(
                              label: adminSquadEngagementDummyData.label,
                              value: adminSquadEngagementDummyData.value,
                              progress: adminSquadEngagementDummyData.progress,
                            ),
                          ),
                          const SizedBox(height: PumpSpacing.md),
                          _SectionCard(
                            title: "TODAY'S GYM CHECK-INS — {count}".tr(
                              namedArgs: {
                                'count': '$adminGymCheckInsDummyData',
                              },
                            ),
                            child: SizedBox(
                              height: 60,
                              child: Center(
                                child: Text('No scans logged yet.'.tr()),
                              ),
                            ),
                          ),
                          const SizedBox(height: PumpSpacing.md),
                          _SectionCard(
                            title: 'WEEKLY PEAK TRAFFIC (MON - SUN)'.tr(),
                            child: Column(
                              children: [
                                for (final day in adminWeeklyTrafficDummyData)
                                  _TrafficRow(day.day, day.progress),
                              ],
                            ),
                          ),
                          const SizedBox(height: PumpSpacing.md),
                          _SectionCard(
                            title: 'POPULAR PLANS'.tr(),
                            child: Column(
                              children: [
                                for (final plan in adminPopularPlansDummyData)
                                  _PlanRow(
                                    name: plan.name,
                                    enrolled: plan.enrolled,
                                    completion: plan.completion,
                                    revenue: plan.revenue,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String value;
  final String label;

  const _MetricCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label.tr(),
            style: const TextStyle(
              fontSize: 9,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final String label;

  const _Bar({
    required this.height,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 7),
          ),
        ],
      ),
    );
  }
}

class _GrowthBar extends StatelessWidget {
  final double height;
  final String month;

  const _GrowthBar({
    required this.height,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          month.tr(),
          style: const TextStyle(fontSize: 8),
        ),
      ],
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;

  const _ProgressRow({
    required this.label,
    required this.value,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label.tr(),
            style: const TextStyle(fontSize: 9),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Theme.of(context).colorScheme.outline,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(value),
      ],
    );
  }
}

class _TrafficRow extends StatelessWidget {
  final String day;
  final double value;

  const _TrafficRow(this.day, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 35,
            child: Text(
              day.tr(),
              style: const TextStyle(fontSize: 9),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: Theme.of(context).colorScheme.outline,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final String name;
  final String enrolled;
  final String completion;
  final String revenue;

  const _PlanRow({
    required this.name,
    required this.enrolled,
    required this.completion,
    required this.revenue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(name),
          ),
          SizedBox(
            width: 40,
            child: Text(enrolled),
          ),
          SizedBox(
            width: 45,
            child: Text(completion),
          ),
          Text(
            revenue,
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
