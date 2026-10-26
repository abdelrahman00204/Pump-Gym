import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pump_gym/dummy_data/admin_athletes_dummy_data.dart';
import 'package:pump_gym/widgets/admin_athlete_card.dart';

import 'test_localization.dart';

void main() {
  setUpAll(initializeTestLocalization);

  testWidgets('Athlete card expands and allows status changes', (tester) async {
    await _pumpAthleteCard(tester);

    expect(find.text('PROFILE DETAILS'), findsNothing);
    await tester.tap(find.text('Elena K.'));
    await tester.pumpAndSettle();

    expect(find.text('PROFILE DETAILS'), findsOneWidget);
    expect(find.text('SUBSCRIPTION USAGE'), findsOneWidget);
    expect(find.text('VISIT CALENDAR'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<bool>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('On track').last);
    await tester.pumpAndSettle();
    expect(find.text('On track'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'VERIFIED'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(OutlinedButton, 'UNVERIFIED'), findsOneWidget);
  });

  testWidgets('Calendar navigates to past months and shows empty days', (
    tester,
  ) async {
    await _pumpAthleteCard(tester);
    await tester.tap(find.text('Elena K.'));
    await tester.pumpAndSettle();

    final now = DateTime.now();
    await tester.tap(find.byTooltip('Previous month'));
    await tester.pumpAndSettle();
    final previousMonth = DateTime(now.year, now.month - 1);
    expect(
      find.text('${_monthName(previousMonth.month)} ${previousMonth.year}'),
      findsOneWidget,
    );

    await tester.tap(find.text('1').last);
    await tester.pumpAndSettle();
    expect(find.text('No visits on this day'), findsOneWidget);
  });
}

Future<void> _pumpAthleteCard(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      child: withTestLocalization(
        (context) => MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: Scaffold(
            body: ListView(
              children: [
                AdminAthleteCard(athlete: adminAthletesDummyData[2]),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await settleTestLocalization(tester);
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
