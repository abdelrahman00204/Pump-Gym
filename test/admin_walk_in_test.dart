import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/screens/admin_screens/admin_walk_in_history_screen.dart';
import 'package:pump_gym/screens/admin_screens/admin_walk_in_screen.dart';
import 'package:pump_gym/widgets/admin_walk_in_check_in_tile.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'test_localization.dart';

void main() {
  setUpAll(initializeTestLocalization);

  testWidgets('Gym QR dialog encodes the gym name', (tester) async {
    await _pumpWalkIn(tester);
    await tester.tap(find.text('SHOW GYM QR'));
    await tester.pumpAndSettle();

    expect(find.text('GYM ENTRANCE QR'), findsOneWidget);
    expect(find.text('PUMP GYM · Main Entrance'), findsOneWidget);
    expect(find.byType(QrImageView), findsOneWidget);
  });

  testWidgets('Member check-in appears in the gym presence list', (
    tester,
  ) async {
    await _pumpWalkIn(tester);
    await tester.tap(find.text('CHECK IN'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(AdminWalkInCheckInTile).first,
        matching: find.text('CHECK IN'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('CURRENTLY IN THE GYM — 4'), findsOneWidget);
    expect(find.text('Alex Carter'), findsOneWidget);
    expect(find.text('WORKOUT FINISHED'), findsNWidgets(4));

    await tester.tap(find.text('WORKOUT FINISHED').first);
    await tester.pumpAndSettle();
    expect(find.text('CURRENTLY IN THE GYM — 3'), findsOneWidget);

    await tester.tap(find.text('WALK-IN HISTORY'));
    await tester.pumpAndSettle();
    expect(find.textContaining('CHECK-OUT:'), findsOneWidget);
  });

  testWidgets('Walk-in visitor is added and appears as inside', (tester) async {
    await _pumpWalkIn(tester);
    await tester.tap(find.text('ADD VISITOR'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'New Guest');
    await tester.tap(find.text('ADD VISITOR').last);
    await tester.pumpAndSettle();

    expect(find.text('New Guest'), findsOneWidget);
    expect(find.text('CURRENTLY IN THE GYM — 4'), findsOneWidget);
  });

  testWidgets('Walk-in history shows the selected day records', (tester) async {
    await _pumpWalkIn(tester);
    await tester.tap(find.text('WALK-IN HISTORY'));
    await tester.pumpAndSettle();

    expect(find.byType(AdminWalkInHistoryScreen), findsOneWidget);
    expect(find.text('abdo'), findsOneWidget);
    expect(find.text('Tom H.'), findsOneWidget);
    expect(find.text('Marcus V.'), findsOneWidget);
    expect(find.text('STILL INSIDE'), findsNWidgets(3));
  });
}

Future<void> _pumpWalkIn(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1000, 1300);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: '/walk-in',
    routes: [
      GoRoute(
        path: '/walk-in',
        builder: (context, state) => const AdminWalkInScreen(),
      ),
      GoRoute(
        path: '/walk-in/history',
        builder: (context, state) => const AdminWalkInHistoryScreen(),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      child: withTestLocalization(
        (context) => MaterialApp.router(
          routerConfig: router,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
        ),
      ),
    ),
  );
  await settleTestLocalization(tester);
}
