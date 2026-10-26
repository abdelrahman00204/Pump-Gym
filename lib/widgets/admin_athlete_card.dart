import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/dummy_data/admin_athletes_dummy_data.dart';
import 'package:pump_gym/theme/pump_colors.dart';
import 'package:pump_gym/theme/theme_provider.dart';

class AdminAthleteCard extends ConsumerStatefulWidget {
  final AdminAthleteDummyData athlete;

  const AdminAthleteCard({super.key, required this.athlete});

  @override
  ConsumerState<AdminAthleteCard> createState() => _AdminAthleteCardState();
}

class _AdminAthleteCardState extends ConsumerState<AdminAthleteCard> {
  late bool _verified;
  late bool _delinquent;
  late DateTime _visibleMonth;
  late DateTime _selectedDate;
  bool _expanded = false;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    _verified = widget.athlete.verified;
    _delinquent = widget.athlete.delinquent;
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDate = _mostRecentVisitThisMonth() ?? _today;
  }

  DateTime? _mostRecentVisitThisMonth() {
    final now = DateTime.now();
    final visits = widget.athlete.visits
        .map((visit) => _dateOnly(visit.date))
        .where((date) => date.year == now.year && date.month == now.month)
        .toList()
      ..sort((a, b) => b.compareTo(a));
    return visits.isEmpty ? null : visits.first;
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool _sameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(pumpPaletteProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: p.secondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.athlete.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.athlete.detail,
                          style: TextStyle(
                            color: p.mutedForeground,
                            fontSize: 9,
                            height: 1.5,
                            letterSpacing: .8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _verifiedBadge(p),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.expand_more,
                    color: p.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: p.border),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _statusDropdown(p),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _verified = !_verified),
                    icon: Icon(
                      _verified ? Icons.verified_outlined : Icons.block,
                      size: 14,
                    ),
                    label: Text(
                      (_verified ? 'VERIFIED' : 'UNVERIFIED').tr(),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          _verified ? p.primary : p.mutedForeground,
                      backgroundColor: _verified
                          ? p.primary.withValues(alpha: .08)
                          : Colors.transparent,
                      side: BorderSide(
                        color: _verified ? p.primary : p.border,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _profileDetails(p),
                  const SizedBox(height: 10),
                  _subscriptionUsage(p),
                  const SizedBox(height: 14),
                  _calendar(p),
                  const SizedBox(height: 8),
                  _visitsPanel(p),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _verifiedBadge(PumpPalette p) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _verified ? p.primary : p.border),
        ),
        child: Text(
          (_verified ? 'VERIFIED' : 'UNVERIFIED').tr(),
          style: TextStyle(
            color: _verified ? p.primary : p.mutedForeground,
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: .6,
          ),
        ),
      );

  Widget _statusDropdown(PumpPalette p) {
    return DropdownButtonFormField<bool>(
      initialValue: _delinquent,
      decoration: InputDecoration(
        //prefixIcon: Icon(Icons.keyboard_arrow_down, color: p.foreground),
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: p.border),
        ),
      ),
      dropdownColor: p.surface,
      items: [
        DropdownMenuItem(value: false, child: Text('On track'.tr())),
        DropdownMenuItem(value: true, child: Text('Delinquent'.tr())),
      ],
      onChanged: (value) {
        if (value != null) setState(() => _delinquent = value);
      },
    );
  }

  Widget _profileDetails(PumpPalette p) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: p.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('PROFILE DETAILS', p),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _detailItem(
                    'MEMBERSHIP',
                    widget.athlete.membership,
                    p,
                  ),
                ),
                Expanded(
                  child: _detailItem('JOINED', widget.athlete.joined, p),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _detailItem('RENEWS', widget.athlete.renews, p),
                ),
                Expanded(
                  child: _detailItem(
                    'COACH',
                    _coachName(widget.athlete.detail),
                    p,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _detailItem(String label, String value, PumpPalette p) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(label, p),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      );

  String _coachName(String detail) {
    final match = RegExp(r'COACH ([^·]+)').firstMatch(detail);
    return match?.group(1)?.trim() ?? '—';
  }

  Widget _subscriptionUsage(PumpPalette p) {
    final limit = widget.athlete.monthlySessionLimit;
    final used = widget.athlete.sessionsUsedThisMonth;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('SUBSCRIPTION USAGE', p),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: limit == 0 ? 0 : (used / limit).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: p.border,
              color: p.primary,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(child: _sectionLabel('SESSIONS THIS MONTH', p)),
              Text(
                '$used / $limit',
                style: TextStyle(
                  color: p.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _calendar(PumpPalette p) {
    final firstDay = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final dayCount =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final leadingEmptyDays = firstDay.weekday % 7;
    final cellCount = ((leadingEmptyDays + dayCount + 6) ~/ 7) * 7;
    final currentMonth = DateTime(_today.year, _today.month);
    final canGoForward = _visibleMonth.isBefore(currentMonth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('VISIT CALENDAR', p),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: p.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Previous month'.tr(),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(
                      () => _visibleMonth = DateTime(
                        _visibleMonth.year,
                        _visibleMonth.month - 1,
                      ),
                    ),
                    icon: Icon(Icons.chevron_left, color: p.mutedForeground),
                  ),
                  Expanded(
                    child: Text(
                      _monthYear(_visibleMonth),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Next month'.tr(),
                    visualDensity: VisualDensity.compact,
                    onPressed: canGoForward
                        ? () => setState(
                              () => _visibleMonth = DateTime(
                                _visibleMonth.year,
                                _visibleMonth.month + 1,
                              ),
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
                          child: _calendarDay(
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
        ),
      ],
    );
  }

  Widget _calendarDay(int day, int dayCount, PumpPalette p) {
    if (day < 1 || day > dayCount) return const SizedBox(height: 38);
    final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
    final isSelected = _sameDate(date, _selectedDate);
    final isToday = _sameDate(date, _today);
    final hasVisit =
        widget.athlete.visits.any((visit) => _sameDate(visit.date, date));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _selectedDate = date),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected ? p.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isToday
                ? Border.all(
                    color: isSelected ? p.primaryForeground : p.primary,
                    width: 1,
                  )
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '$day',
                style: TextStyle(
                  color: isSelected ? p.primaryForeground : p.foreground,
                  fontSize: 10,
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              if (hasVisit)
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isSelected ? p.primaryForeground : p.primary,
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

  Widget _visitsPanel(PumpPalette p) {
    final visits = widget.athlete.visits
        .where((visit) => _sameDate(visit.date, _selectedDate))
        .toList();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(
            'VISITS ON {date}',
            p,
            namedArgs: {'date': _isoDate(_selectedDate)},
          ),
          const SizedBox(height: 8),
          if (visits.isEmpty)
            Text(
              'No visits on this day'.tr(),
              style: TextStyle(
                color: p.mutedForeground,
                fontSize: 11,
              ),
            )
          else
            for (final visit in visits)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Check-in {time}'.tr(
                          namedArgs: {'time': visit.checkIn},
                        ),
                        style: TextStyle(
                          color: p.mutedForeground,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Text(
                      'Check-out {time}'.tr(
                        namedArgs: {'time': visit.checkOut},
                      ),
                      style: TextStyle(
                        color: p.mutedForeground,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget _sectionLabel(
    String text,
    PumpPalette p, {
    Map<String, String>? namedArgs,
  }) =>
      Text(
        text.tr(namedArgs: namedArgs),
        style: TextStyle(
          color: p.mutedForeground,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      );

  String _monthYear(DateTime date) => '{month} {year}'.tr(namedArgs: {
        'month': _monthName(date.month).tr(),
        'year': '${date.year}',
      });

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

  String _isoDate(DateTime date) => '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
