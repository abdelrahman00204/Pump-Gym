import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeTestLocalization() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
}

Widget withTestLocalization(Widget Function(BuildContext context) appBuilder) =>
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      saveLocale: false,
      assetLoader: const _TestAssetLoader(),
      child: Builder(builder: appBuilder),
    );

Future<void> settleTestLocalization(WidgetTester tester) async {
  await tester.pump();
  await tester.pumpAndSettle();
}

class _TestAssetLoader extends AssetLoader {
  const _TestAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    final translations = Map<String, dynamic>.from(
      jsonDecode(File('$path\\${locale.languageCode}.json').readAsStringSync())
          as Map,
    );
    return SynchronousFuture(translations);
  }
}
