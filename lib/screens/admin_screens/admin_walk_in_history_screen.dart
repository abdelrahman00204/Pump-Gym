import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/admin_shell.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/constants/app_routes.dart';
import 'package:pump_gym/features/providers/admin_walk_in_provider.dart';
import 'package:pump_gym/theme/pump_colors.dart';
import 'package:pump_gym/theme/theme_provider.dart';
import 'package:pump_gym/widgets/admin_top_bar.dart';
import 'package:pump_gym/widgets/admin_walk_in_history_calendar.dart';
import 'package:pump_gym/wide_layout.dart';

class AdminWalkInHistoryScreen extends ConsumerStatefulWidget {
  const AdminWalkInHistoryScreen({super.key});

  @override
  ConsumerState<AdminWalkInHistoryScreen> createState() =>
      _AdminWalkInHistoryScreenState();
}

class _AdminWalkInHistoryScreenState
    extends ConsumerState<AdminWalkInHistoryScreen> {
  late DateTime _visibleMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  bool _sameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  String _dateLabel(DateTime date) => '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  String _time(DateTime date) => '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(pumpPaletteProvider);
    final records = ref.watch(adminWalkInRecordsProvider);
    final visitDates = records
        .map((record) => DateTime(
              record.checkedInAt.year,
              record.checkedInAt.month,
              record.checkedInAt.day,
            ))
        .toSet();
    final dayRecords = records
        .where((record) => _sameDate(record.checkedInAt, _selectedDate))
        .toList()
      ..sort((a, b) => b.checkedInAt.compareTo(a.checkedInAt));

    return AdminShell(
      body: Column(
        children: [
          if (!showsDesktopTopNav(context)) const AdminTopBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 120),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'WALK-IN HISTORY'.tr(),
                        style: TextStyle(
                          color: p.foreground,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.go(AppRoutes.walkIn),
                      icon: const Icon(Icons.keyboard_return, size: 15),
                      label: Text('BACK TO WALK-IN'.tr()),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AdminWalkInHistoryCalendar(
                  visibleMonth: _visibleMonth,
                  selectedDate: _selectedDate,
                  visitDates: visitDates,
                  onMonthChanged: (month) =>
                      setState(() => _visibleMonth = month),
                  onDateSelected: (date) =>
                      setState(() => _selectedDate = date),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: p.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: p.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _dateLabel(_selectedDate),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (dayRecords.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              'No visits on this day'.tr(),
                              style: TextStyle(color: p.mutedForeground),
                            ),
                          ),
                        )
                      else
                        PumpCardGrid(
                          compact: 1,
                          medium: 1,
                          expanded: 2,
                          spacing: 0,
                          children: [
                            for (final record in dayRecords)
                              _HistoryRecord(
                                name: record.name,
                                checkedIn: _time(record.checkedInAt),
                                source: record.source,
                                oneTimeVisitor: record.oneTimeVisitor,
                                checkedOutAt: record.checkedOutAt == null
                                    ? null
                                    : _time(record.checkedOutAt!),
                                p: p,
                              ),
                          ],
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

class _HistoryRecord extends StatelessWidget {
  final String name;
  final String checkedIn;
  final String source;
  final bool oneTimeVisitor;
  final String? checkedOutAt;
  final PumpPalette p;

  const _HistoryRecord({
    required this.name,
    required this.checkedIn,
    required this.source,
    required this.oneTimeVisitor,
    required this.checkedOutAt,
    required this.p,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: p.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: p.primary.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  (oneTimeVisitor ? 'ONE-TIME VISITOR' : 'REGISTERED ATHLETE')
                      .tr(),
                  style: TextStyle(
                    color: oneTimeVisitor ? p.mutedForeground : p.primary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'CHECK-IN: {time} · {source}'.tr(namedArgs: {
              'time': checkedIn,
              'source': source.tr(),
            }),
            style: TextStyle(
              color: p.mutedForeground,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: .7,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            checkedOutAt == null
                ? 'STILL INSIDE'.tr()
                : 'CHECK-OUT: {time}'.tr(
                    namedArgs: {'time': checkedOutAt!},
                  ),
            style: TextStyle(
              color: checkedOutAt == null ? p.primary : p.mutedForeground,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: .7,
            ),
          ),
        ],
      ),
    );
  }
}
