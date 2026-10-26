import 'package:flutter/material.dart';

import 'pump_colors.dart';

class ThemeOption {
  final String name;
  final List<Color> swatch;
  final String? tag;
  final PumpThemeId themeId;

  const ThemeOption(this.name, this.swatch, this.tag, this.themeId);
}

final List<ThemeOption> themeOptions = [
  ThemeOption(
    'Volt Lime & Obsidian',
    [
      PumpPalettes.byId(PumpThemeId.lime).primary,
      PumpPalettes.byId(PumpThemeId.lime).primaryForeground,
    ],
    'DEFAULT',
    PumpThemeId.lime,
  ),
  ThemeOption(
    'PUMP Crimson & Obsidian',
    [
      PumpPalettes.byId(PumpThemeId.crimson).primary,
      PumpPalettes.byId(PumpThemeId.crimson).primaryForeground,
    ],
    null,
    PumpThemeId.crimson,
  ),
  ThemeOption(
    'Eye-Care Calm Teal',
    [
      PumpPalettes.byId(PumpThemeId.teal).primary,
      PumpPalettes.byId(PumpThemeId.teal).secondary,
    ],
    null,
    PumpThemeId.teal,
  ),
  ThemeOption(
    'Midnight Emerald',
    [
      PumpPalettes.byId(PumpThemeId.emerald).primary,
      PumpPalettes.byId(PumpThemeId.emerald).secondary,
    ],
    null,
    PumpThemeId.emerald,
  ),
  ThemeOption(
    'Warm Amber Glow',
    [
      PumpPalettes.byId(PumpThemeId.amber).primary,
      PumpPalettes.byId(PumpThemeId.amber).secondary,
    ],
    null,
    PumpThemeId.amber,
  ),
  ThemeOption(
    'Titanium Slate',
    [
      PumpPalettes.byId(PumpThemeId.slate).primary,
      PumpPalettes.byId(PumpThemeId.slate).secondary,
    ],
    null,
    PumpThemeId.slate,
  ),
];
