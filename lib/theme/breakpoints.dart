import 'package:flutter/widgets.dart';

/// Binding breakpoint thresholds — spec §2.9.
///
/// These are the ONLY thresholds used anywhere in the app. The breakpoint
/// switch changes navigation chrome and grid density only — never which
/// features exist. Do not hand-roll a second breakpoint system per screen
/// or per platform; everything imports this file.
class PumpBreakpoints {
  const PumpBreakpoints._();

  /// Below this: single column, bottom tab bar, icon-only nav.
  static const double compactMax = 768;

  /// Below this (and >= compactMax): sidebar rail (icons + labels).
  static const double mediumMax = 1024;
  // >= mediumMax: expanded desktop layout, capped max-width content column.
}

enum PumpLayoutSize { compact, medium, expanded }

/// Reads window width via MediaQuery — works identically whether the app
/// is compiled for mobile, web, or desktop. Never branch this on
/// `Platform.isX` / `kIsWeb`; a wide browser window and a desktop window
/// must resolve to the same layout as a wide phone would.
PumpLayoutSize pumpLayoutSizeOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= PumpBreakpoints.mediumMax) return PumpLayoutSize.expanded;
  if (width >= PumpBreakpoints.compactMax) return PumpLayoutSize.medium;
  return PumpLayoutSize.compact;
}
