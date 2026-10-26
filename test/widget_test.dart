import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pump_gym/features/providers/session_provider.dart';
import 'package:pump_gym/main.dart';
import 'package:pump_gym/screens/athlete_screens/session_screen.dart';
import 'package:pump_gym/theme/pump_colors.dart';
import 'package:pump_gym/theme/theme_provider.dart';

import 'test_localization.dart';

void main() {
  setUpAll(() async {
    await initializeTestLocalization();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('App restores the saved theme on startup', (tester) async {
    final storage = _FakeThemeStorage('teal');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [themeStorageProvider.overrideWithValue(storage)],
        child: const MyApp(),
      ),
    );
    await settleTestLocalization(tester);

    expect(find.text('PUMP GYM OS'), findsOneWidget);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(
      app.theme!.colorScheme.primary,
      PumpPalettes.byId(PumpThemeId.teal).primary,
    );
  });

  testWidgets('Logging a set starts a rest timer with add and skip controls', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SessionScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionElapsedProvider.overrideWith((ref) => Stream.value(0)),
        ],
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
    await Scrollable.ensureVisible(
      tester.element(find.text('LOG SET')),
      alignment: 0.4,
    );
    await tester.tap(find.text('LOG SET'));
    await tester.pump();

    expect(find.text('REST TIMER — AUTO-STARTED AFTER SET'), findsOneWidget);
    expect(find.text('01:30'), findsOneWidget);

    await Scrollable.ensureVisible(
      tester.element(find.text('+15S')),
      alignment: 0.4,
    );
    await tester.tap(find.text('+15S'));
    await tester.pump();
    expect(find.text('01:45'), findsOneWidget);

    await Scrollable.ensureVisible(
      tester.element(find.text('+30S')),
      alignment: 0.4,
    );
    await tester.tap(find.text('+30S'));
    await tester.pump();
    expect(find.text('02:15'), findsOneWidget);

    await Scrollable.ensureVisible(
      tester.element(find.text('SKIP REST')),
      alignment: 0.4,
    );
    await tester.tap(find.text('SKIP REST'));
    await tester.pump();
    expect(find.text('REST TIMER — AUTO-STARTED AFTER SET'), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}

class _FakeThemeStorage implements ThemeStorage {
  _FakeThemeStorage(this.savedTheme);

  String? savedTheme;

  @override
  Future<String?> readTheme() async => savedTheme;

  @override
  Future<void> writeTheme(String themeName) async {
    savedTheme = themeName;
  }
}
