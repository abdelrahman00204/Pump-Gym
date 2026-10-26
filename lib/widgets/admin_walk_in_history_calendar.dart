import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/theme/theme_provider.dart';

class AdminWalkInHistoryCalendar extends ConsumerWidget {
  final DateTime visibleMonth;
  final DateTime selectedDate;
  final Set<DateTime> visitDates;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  const AdminWalkInHistoryCalendar({
    super.key,
    required this.visibleMonth,
    required this.selectedDate,
    required this.visitDates,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _sameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(pumpPaletteProvider);
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final dayCount = DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final leadingEmptyDays = firstDay.weekday % 7;
    final cellCount = ((leadingEmptyDays + dayCount + 6) ~/ 7) * 7;
    final currentMonth = DateTime(_today.year, _today.month);
    final canGoForward = visibleMonth.isBefore(currentMonth);

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
      decoration: BoxDecoration(
        color: p.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Previous month'.tr(),
                onPressed: () => onMonthChanged(
                  DateTime(visibleMonth.year, visibleMonth.month - 1),
                ),
                icon: Icon(Icons.chevron_left, color: p.mutedForeground),
              ),
              Expanded(
                child: Text(
                  '{month} {year}'.tr(namedArgs: {
                    'month': _monthName(visibleMonth.month).tr(),
                    'year': '${visibleMonth.year}',
                  }),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Next month'.tr(),
                onPressed: canGoForward
                    ? () => onMonthChanged(
                          DateTime(visibleMonth.year, visibleMonth.month + 1),
                        )
                    : null,
                icon: Icon(
                  Icons.chevron_right,
                  color: canGoForward ? p.mutedForeground : p.border,
                ),
              ),
            ],
          ),
          Row(
            children: const ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 6),
          for (var row = 0; row < cellCount; row += 7)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  for (var column = 0; column < 7; column++)
                    Expanded(
                      child: _dayCell(
                        row + column - leadingEmptyDays + 1,
                        dayCount,
                        p,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _dayCell(int day, int dayCount, p) {
    if (day < 1 || day > dayCount) return const SizedBox(height: 48);
    final date = DateTime(visibleMonth.year, visibleMonth.month, day);
    final selected = _sameDate(date, selectedDate);
    final today = _sameDate(date, _today);
    final hasVisits = visitDates.any((visitDate) => _sameDate(visitDate, date));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: () => onDateSelected(date),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: selected ? p.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: today
                ? Border.all(
                    color: selected ? p.primaryForeground : p.primary,
                  )
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '$day',
                style: TextStyle(
                  color: selected ? p.primaryForeground : p.foreground,
                  fontSize: 10,
                  fontWeight:
                      selected || today ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (hasVisits)
                Positioned(
                  bottom: 5,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: selected ? p.primaryForeground : p.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) => const [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ][month - 1];
}
