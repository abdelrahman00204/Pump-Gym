import 'package:flutter/material.dart';

/// Matches SubscriptionStatus-style canonical enums (§12.1): six fixed
/// values, used verbatim as UserDto.preferredThemeId strings ("lime",
/// "crimson", "teal", "emerald", "amber", "slate").
enum PumpThemeId { lime, crimson, teal, emerald, amber, slate }

@immutable
class PumpPalette {
  final Color background;
  final Color surface;
  final Color secondary;
  final Color border;
  final Color primary;
  final Color primaryForeground;
  final Color foreground;
  final Color mutedForeground;
  final Color destructive;

  const PumpPalette({
    required this.background,
    required this.surface,
    required this.secondary,
    required this.border,
    required this.primary,
    required this.primaryForeground,
    required this.foreground,
    required this.mutedForeground,
    required this.destructive,
  });
}

/// Canonical hex values — spec §2.2, copied verbatim. Never re-type a hex
/// code anywhere else in the app; reference `PumpPalettes.byId(themeId)`.
class PumpPalettes {
  const PumpPalettes._();

  static const Map<PumpThemeId, PumpPalette> _all = {
    PumpThemeId.lime: PumpPalette(
      background: Color(0xFF0F0F0E),
      surface: Color(0xFF1A1A18),
      secondary: Color(0xFF232321),
      border: Color(0xFF2E2E2A),
      primary: Color(0xFFD4F542),
      primaryForeground: Color(0xFF121210),
      foreground: Color(0xFFF2F2EF),
      mutedForeground: Color(0xFF9A9DA0),
      destructive: Color(0xFFEF4444),
    ),
    PumpThemeId.crimson: PumpPalette(
      background: Color(0xFF0A0A0C),
      surface: Color(0xFF151517),
      secondary: Color(0xFF212124),
      border: Color(0xFF2B2B2E),
      primary: Color(0xFFFF1E38),
      primaryForeground: Color(0xFFFFFFFF),
      foreground: Color(0xFFF5F5F5),
      mutedForeground: Color(0xFF98979C),
      destructive: Color(0xFFEF4444),
    ),
    PumpThemeId.teal: PumpPalette(
      background: Color(0xFF12181F),
      surface: Color(0xFF1A222B),
      secondary: Color(0xFF232C36),
      border: Color(0xFF2E3944),
      primary: Color(0xFF2DD4BF),
      primaryForeground: Color(0xFF0B1613),
      foreground: Color(0xFFEAF6F4),
      mutedForeground: Color(0xFF8FA3A0),
      destructive: Color(0xFFEF4444),
    ),
    PumpThemeId.emerald: PumpPalette(
      background: Color(0xFF050F0A),
      surface: Color(0xFF0C1E15),
      secondary: Color(0xFF152C1F),
      border: Color(0xFF20402C),
      primary: Color(0xFF34D399),
      primaryForeground: Color(0xFF052E1B),
      foreground: Color(0xFFE7F5EC),
      mutedForeground: Color(0xFF8AAB96),
      destructive: Color(0xFFEF4444),
    ),
    PumpThemeId.amber: PumpPalette(
      background: Color(0xFF0F0A05),
      surface: Color(0xFF1C130A),
      secondary: Color(0xFF241A0C),
      border: Color(0xFF2E2110),
      primary: Color(0xFFFBBF24),
      primaryForeground: Color(0xFF1C1206),
      foreground: Color(0xFFF2EBDD),
      mutedForeground: Color(0xFFA99A82),
      destructive: Color(0xFFEF4444),
    ),
    PumpThemeId.slate: PumpPalette(
      background: Color(0xFF0A0E16),
      surface: Color(0xFF141B26),
      secondary: Color(0xFF1C2532),
      border: Color(0xFF242E3D),
      primary: Color(0xFFCBD5E1),
      primaryForeground: Color(0xFF0F172A),
      foreground: Color(0xFFEEF2F7),
      mutedForeground: Color(0xFF93A0B3),
      destructive: Color(0xFFEF4444),
    ),
  };

  static PumpPalette byId(PumpThemeId id) => _all[id]!;
}
