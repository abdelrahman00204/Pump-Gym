import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'pump_colors.dart';

const _secureStorage = FlutterSecureStorage();

const _themeStorageKey = 'preferred_theme';

abstract interface class ThemeStorage {
  Future<String?> readTheme();
  Future<void> writeTheme(String themeName);
}

class SecureThemeStorage implements ThemeStorage {
  const SecureThemeStorage();

  @override
  Future<String?> readTheme() {
    return _secureStorage.read(key: _themeStorageKey);
  }

  @override
  Future<void> writeTheme(String themeName) {
    return _secureStorage.write(key: _themeStorageKey, value: themeName);
  }
}

final themeStorageProvider = Provider<ThemeStorage>((ref) {
  return const SecureThemeStorage();
});

final themeProvider =
    NotifierProvider<ThemeNotifier, PumpThemeId>(ThemeNotifier.new);

final pumpPaletteProvider = Provider<PumpPalette>((ref) {
  final themeId = ref.watch(themeProvider);
  return PumpPalettes.byId(themeId);
});

class ThemeNotifier extends Notifier<PumpThemeId> {
  bool _themeWasSet = false;

  @override
  PumpThemeId build() {
    // Default theme while the saved theme is being loaded.
    return PumpThemeId.lime;
  }

  Future<void> loadTheme() async {
    final savedTheme = await ref.read(themeStorageProvider).readTheme();

    if (_themeWasSet || savedTheme == null) {
      return;
    }

    try {
      state = PumpThemeId.values.byName(savedTheme);
    } on ArgumentError {
      // Invalid/old value → use default.
      state = PumpThemeId.lime;
    }
  }

  Future<void> setTheme(PumpThemeId theme) async {
    _themeWasSet = true;

    // Update the whole app immediately.
    state = theme;

    // Save it permanently on the device.
    await ref.read(themeStorageProvider).writeTheme(theme.name);
  }
}
