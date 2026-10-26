import 'package:flutter/material.dart';
import 'package:pump_gym/theme/breakpoints.dart';
import 'package:pump_gym/theme/pump_theme.dart';

/// Picks a value by the current layout size. [medium] falls back to [compact].
T pumpPick<T>(
  BuildContext context, {
  required T compact,
  T? medium,
  required T expanded,
}) {
  switch (pumpLayoutSizeOf(context)) {
    case PumpLayoutSize.compact:
      return compact;
    case PumpLayoutSize.medium:
      return medium ?? compact;
    case PumpLayoutSize.expanded:
      return expanded;
  }
}

/// Two-column page layout for wide screens.
///
/// Pass the SAME section widgets you already have, split into [main] and
/// [side]. On phones and tablets everything stacks in one column
/// (main first, then side), exactly like before. On desktop (expanded) the
/// two lists become two columns side by side.
class PumpColumns extends StatelessWidget {
  final List<Widget> main;
  final List<Widget> side;
  final int mainFlex;
  final int sideFlex;

  /// Horizontal gap between the two columns.
  final double gap;

  /// Vertical gap between cards inside one column.
  final double spacing;

  const PumpColumns({
    super.key,
    required this.main,
    required this.side,
    this.mainFlex = 3,
    this.sideFlex = 2,
    this.gap = PumpSpacing.xl,
    this.spacing = PumpSpacing.lg,
  });

  Widget _stack(List<Widget> items) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) SizedBox(height: spacing),
            items[i],
          ],
        ],
      );

  @override
  Widget build(BuildContext context) {
    if (pumpLayoutSizeOf(context) != PumpLayoutSize.expanded) {
      return _stack([...main, ...side]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: mainFlex, child: _stack(main)),
        SizedBox(width: gap),
        Expanded(flex: sideFlex, child: _stack(side)),
      ],
    );
  }
}

/// Grid of cards whose column count depends on the layout size.
/// Rows are built with Expanded cells, so cards keep their natural height
/// (no fixed aspect ratio needed).
class PumpCardGrid extends StatelessWidget {
  final List<Widget> children;
  final int compact;
  final int medium;
  final int expanded;
  final double spacing;

  const PumpCardGrid({
    super.key,
    required this.children,
    this.compact = 2,
    this.medium = 3,
    this.expanded = 4,
    this.spacing = PumpSpacing.sm,
  });

  @override
  Widget build(BuildContext context) {
    final columns = pumpPick(
      context,
      compact: compact,
      medium: medium,
      expanded: expanded,
    );

    return Column(
      children: [
        for (int i = 0; i < children.length; i += columns)
          Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int c = 0; c < columns; c++) ...[
                  if (c > 0) SizedBox(width: spacing),
                  Expanded(
                    child: i + c < children.length
                        ? children[i + c]
                        : const SizedBox(),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// The "SESSION RUNNING" pill pinned to the bottom of a screen's Stack.
/// Replaces `Positioned(left:, right:, bottom:, child: _SessionRunningBar())`.
/// On wide screens it stays a centered pill (max 640px) instead of
/// stretching across the whole window.
class PumpFloatingBar extends StatelessWidget {
  final Widget child;
  const PumpFloatingBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: PumpSpacing.lg,
      right: PumpSpacing.lg,
      bottom: PumpSpacing.sm,
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: child,
        ),
      ),
    );
  }
}