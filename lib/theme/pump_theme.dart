import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pump_colors.dart';

/// Spacing scale — spec §2.4, 8pt-ish grid. Logical px.
class PumpSpacing {
  const PumpSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}

/// Corner radius — spec §2.4.
class PumpRadius {
  const PumpRadius._();
  static const double card = 20; // rounded-2xl
  static const double pill = 9999; // buttons/pills, chips
  static const double modal = 24; // rounded-3xl
}

/// Type scale — spec §2.3. Anton for display, Inter for everything else.
///
/// RTL note: `label` normally uses 0.16em tracking, but wide letter-spacing
/// breaks in Arabic — pass `isRtl: true` to zero it out, per §2.3.
class PumpTextStyles {
  const PumpTextStyles._();

  static TextStyle display2xl(Color c) => GoogleFonts.anton(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 32 * 0.03,
        color: c,
      );

  static TextStyle displayXl(Color c) => GoogleFonts.anton(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 24 * 0.03,
        color: c,
      );

  static TextStyle displayLg(Color c) => GoogleFonts.anton(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        letterSpacing: 20 * 0.03,
        color: c,
      );

  static TextStyle bodyLg(Color c) =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: c);

  static TextStyle bodyMd(Color c) =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: c);

  static TextStyle bodySm(Color c) =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: c);

  static TextStyle label(Color c, {bool isRtl = false}) => GoogleFonts.inter(
        fontSize: 9.5,
        fontWeight: FontWeight.w700,
        letterSpacing: isRtl ? 0 : 9.5 * 0.16,
        color: c,
      );
}

/// Single source of the app's Material 3 ThemeData. Both the User Interface
/// and the Admin Interface must import this — neither defines its own
/// colors, fonts, or spacing constants (§2 preamble).
class PumpTheme {
  const PumpTheme._();

  static ThemeData build(PumpThemeId id, {bool isRtl = false}) {
    final p = PumpPalettes.byId(id);

    final colorScheme = ColorScheme.dark(
      surface: p.background,
      onSurface: p.foreground,
      primary: p.primary,
      onPrimary: p.primaryForeground,
      secondary: p.secondary,
      onSecondary: p.foreground,
      error: p.destructive,
      onError: p.primaryForeground,
      outline: p.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: p.background,
      cardColor: p.surface,
      dividerColor: p.border,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: TextTheme(
        displayLarge: PumpTextStyles.display2xl(p.foreground),
        displayMedium: PumpTextStyles.displayXl(p.foreground),
        displaySmall: PumpTextStyles.displayLg(p.foreground),
        bodyLarge: PumpTextStyles.bodyLg(p.foreground),
        bodyMedium: PumpTextStyles.bodyMd(p.foreground),
        bodySmall: PumpTextStyles.bodySm(p.mutedForeground),
        labelSmall: PumpTextStyles.label(p.mutedForeground, isRtl: isRtl),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PumpRadius.card),
          side: BorderSide(color: p.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.primaryForeground,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: PumpSpacing.xxl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PumpRadius.pill),
          ),
          textStyle: PumpTextStyles.bodyMd(p.primaryForeground),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.secondary,
        selectedColor: p.primary,
        labelStyle: PumpTextStyles.label(p.foreground, isRtl: isRtl),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PumpRadius.pill),
          side: BorderSide(color: p.border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PumpRadius.modal),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        indicatorColor: p.primary.withValues(alpha: 0.16),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: p.surface,
        selectedIconTheme: IconThemeData(color: p.primary),
        unselectedIconTheme: IconThemeData(color: p.mutedForeground),
      ),
    );
  }
}
