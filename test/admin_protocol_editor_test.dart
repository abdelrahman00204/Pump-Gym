import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/screens/admin_screens/admin_plan_builder_screen.dart';

import 'test_localization.dart';

void main() {
  setUpAll(initializeTestLocalization);

  testWidgets('New protocol can be created from the plan builder', (
    tester,
  ) async {
    await _pumpPlanBuilder(tester);

    await tester.tap(find.text('NEW PROTOCOL'));
    await tester.pumpAndSettle();

    expect(find.text('NEW PROTOCOL'), findsNWidgets(2));
    await tester.enterText(find.byType(TextFormField).at(0), 'Test Protocol');
    await tester.enterText(find.byType(TextFormField).at(1), 'Coach Test');
    await tester.enterText(find.byType(TextFormField).at(2), '25');
    await tester.enterText(find.byType(TextFormField).at(3), '+1 KG');
    await tester.tap(find.text('SAVE PROTOCOL'));
    await tester.pumpAndSettle();

    expect(find.text('Test Protocol'), findsOneWidget);
  });

  testWidgets('Existing protocol can be edited and saved', (tester) async {
    await _pumpPlanBuilder(tester);

    await tester.tap(find.byTooltip('Edit protocol').first);
    await tester.pumpAndSettle();

    expect(find.text('EDIT PROTOCOL'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'Updated Matrix');
    await tester.tap(find.text('SAVE PROTOCOL'));
    await tester.pumpAndSettle();

    expect(find.text('Updated Matrix'), findsOneWidget);
    expect(find.text('Hypertrophy Matrix'), findsNothing);
  });
}

Future<void> _pumpPlanBuilder(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1000, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/protocols',
        builder: (context, state) => const AdminPlanBuilderScreen(),
      ),
    ],
    initialLocation: '/protocols',
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
