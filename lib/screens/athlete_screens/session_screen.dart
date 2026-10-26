import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pump_gym/athlete_shell.dart';
import 'package:pump_gym/constants/app_routes.dart';
import 'package:pump_gym/dummy_data/session_dummy_data.dart';
import 'package:pump_gym/theme/pump_colors.dart';
import 'package:pump_gym/theme/pump_theme.dart';
import 'package:pump_gym/features/providers/session_provider.dart';
import 'package:pump_gym/theme/theme_provider.dart';
import 'package:pump_gym/widgets/rest_timer.dart';
import 'package:pump_gym/widgets/session_timer.dart';
import 'package:pump_gym/widgets/session_running.dart';
import 'package:pump_gym/widgets/top_bar.dart';
import 'package:pump_gym/wide_layout.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  Timer? _restTimer;
  int? _restSecondsRemaining;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(sessionStartProvider.notifier).startIfNeeded();
    });
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  void _logSet() {
    final sessionState = ref.read(sessionUiProvider);
    final setLimit =
        sessionState.stationWorkout ? sessionState.stationTargetSets : 4;
    if (sessionState.loggedSets >= setLimit) return;

    ref.read(sessionUiProvider.notifier).logSet(setLimit: setLimit);
    _restTimer?.cancel();
    setState(
      () => _restSecondsRemaining = sessionDefaultRestSecondsDummyData,
    );
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final remaining = _restSecondsRemaining;
      if (remaining == null || remaining <= 1) {
        timer.cancel();
        setState(() => _restSecondsRemaining = null);
        return;
      }

      setState(() => _restSecondsRemaining = remaining - 1);
    });
  }

  void _adjustRestTime(int seconds) {
    final remaining = _restSecondsRemaining;
    if (remaining == null) return;
    setState(() => _restSecondsRemaining = remaining + seconds);
  }

  void _skipRest() {
    _restTimer?.cancel();
    _restTimer = null;
    setState(() => _restSecondsRemaining = null);
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(pumpPaletteProvider);
    final sessionState = ref.watch(sessionUiProvider);
    final seconds = ref.watch(sessionElapsedProvider).value ?? 0;
    final setLimit = sessionState.stationWorkout
        ? sessionState.stationTargetSets
        : sessionDefaultSetTargetDummyData;
    return AthleteShell(
      body: Stack(
        children: [
          Column(
            children: [
              if (!showsDesktopTopNav(context))
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    PumpSpacing.lg,
                    PumpSpacing.md,
                    PumpSpacing.lg,
                    PumpSpacing.sm,
                  ),
                  child: TopBar(
                    canPop: true,
                    onBack: () => context.go(AppRoutes.lobby),
                  ),
                ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    PumpSpacing.lg,
                    PumpSpacing.sm,
                    PumpSpacing.lg,
                    120,
                  ),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sessionState.stationWorkout
                                ? '{machine} — STATION WORKOUT'.tr(
                                    namedArgs: {
                                      'machine':
                                          sessionState.machine.toUpperCase(),
                                    },
                                  )
                                : 'DAY {day} — {type}\n{focus}'.tr(
                                    namedArgs: {
                                      'day':
                                          '$sessionManualWorkoutDayDummyData',
                                      'type': sessionManualWorkoutTypeDummyData
                                          .tr(),
                                      'focus':
                                          sessionManualWorkoutFocusDummyData
                                              .tr(),
                                    },
                                  ),
                            style: PumpTextStyles.label(p.foreground)
                                .copyWith(height: 1.35),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.go(AppRoutes.lobby),
                          icon: const Icon(Icons.logout, size: 15),
                          label: Text('EXIT & KEEP RUNNING'.tr()),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: p.foreground,
                            side: BorderSide(color: p.border),
                            textStyle: PumpTextStyles.label(p.foreground),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PumpSpacing.md),
                    SessionTimer(
                      elapsed: _formatDuration(seconds),
                      palette: p,
                    ),
                    if (_restSecondsRemaining case final remaining?) ...[
                      const SizedBox(height: PumpSpacing.md),
                      RestTimer(
                        remainingSeconds: remaining,
                        totalSeconds: sessionDefaultRestSecondsDummyData,
                        palette: p,
                        onAddTime: _adjustRestTime,
                        onSkip: _skipRest,
                      ),
                    ],
                    const SizedBox(height: PumpSpacing.md),
                    if (sessionState.stationWorkout)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 8),
                          decoration: BoxDecoration(
                            color: p.primary,
                            borderRadius:
                                BorderRadius.circular(PumpRadius.pill),
                          ),
                          child: Text(
                            '${sessionState.stationMuscleGroup?.tr().toUpperCase() ?? 'STATION'.tr()} '
                            '${sessionState.loggedSets}/${sessionState.stationTargetSets}',
                            style: PumpTextStyles.label(p.primaryForeground),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: sessionExerciseGroupsDummyData.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: PumpSpacing.sm),
                          itemBuilder: (context, index) => ChoiceChip(
                            label: Text(
                                sessionExerciseGroupsDummyData[index].tr()),
                            selected: index == sessionState.selectedMuscleGroup,
                            onSelected: (_) => ref
                                .read(sessionUiProvider.notifier)
                                .selectMuscleGroup(index),
                            labelStyle: PumpTextStyles.label(
                              index == sessionState.selectedMuscleGroup
                                  ? p.primaryForeground
                                  : p.mutedForeground,
                            ),
                            backgroundColor: p.surface,
                            selectedColor: p.primary,
                            side: BorderSide(color: p.border),
                          ),
                        ),
                      ),
                    if (!sessionState.stationWorkout) ...[
                      const SizedBox(height: PumpSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _OutlineAction(
                              icon: Icons.swap_horiz,
                              label: 'SWAP MACHINE'.tr(),
                              palette: p,
                              onTap: _swapMachine,
                            ),
                          ),
                          const SizedBox(width: PumpSpacing.sm),
                          Expanded(
                            child: _OutlineAction(
                              icon: Icons.add,
                              label: 'ADD MACHINE'.tr(),
                              palette: p,
                              onTap: _addMachine,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: PumpSpacing.md),
                    _ExerciseCard(
                      machine: sessionState.machine,
                      weight: sessionState.weight,
                      reps: sessionState.reps,
                      loggedSets: sessionState.loggedSets,
                      setLimit: setLimit,
                      palette: p,
                      onWeightChanged: (delta) => ref
                          .read(sessionUiProvider.notifier)
                          .adjustWeight(delta),
                      onRepsChanged: (delta) => ref
                          .read(sessionUiProvider.notifier)
                          .adjustReps(delta),
                      onLogSet: _logSet,
                    ),
                    if (!sessionState.stationWorkout)
                      for (final machine
                          in sessionState.additionalMachines) ...[
                        const SizedBox(height: PumpSpacing.md),
                        _AddedMachineCard(machine: machine, palette: p),
                      ],
                    const SizedBox(height: PumpSpacing.md),
                    OutlinedButton.icon(
                      onPressed: _finishWorkout,
                      icon: Icon(Icons.flag_outlined, color: p.primary),
                      label: Text(
                        'FINISH WORKOUT'.tr(),
                        style: PumpTextStyles.label(p.primary),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        side: BorderSide(color: p.border),
                        shape: const StadiumBorder(),
                      ),
                    ),
                    const SizedBox(height: PumpSpacing.sm),
                    Text(
                      'SAFEGUARD: UNFINISHED SET(S) TRIGGER\nCONFIRMATION BEFORE DEBRIEF.'
                          .tr(),
                      textAlign: TextAlign.center,
                      style: PumpTextStyles.label(p.mutedForeground),
                    ),
                  ],
                ),
              ),
            ],
          ),
          PumpFloatingBar(
            child: SessionRunningBar(
              onTap: () {},
              elapsed: _formatDuration(seconds),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _swapMachine() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => _MachinePicker(
        title: 'Swap exercise machine'.tr(),
        options: sessionSwapMachineOptionsDummyData,
      ),
    );
    if (selected != null && mounted) {
      ref.read(sessionUiProvider.notifier).swapMachine(selected);
    }
  }

  Future<void> _addMachine() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => _MachinePicker(
        title: 'Add a machine'.tr(),
        options: sessionAddMachineOptionsDummyData,
      ),
    );
    if (selected != null && mounted) {
      ref.read(sessionUiProvider.notifier).addMachine(selected);
    }
  }

  Future<void> _finishWorkout() async {
    final shouldFinish = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Finish workout?'.tr()),
        content: Text('Your active session timer will stop.'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Keep training'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Finish'.tr()),
          ),
        ],
      ),
    );
    if (shouldFinish == true && mounted) {
      ref.read(sessionStartProvider.notifier).finish();
      ref.read(sessionUiProvider.notifier).reset();
      context.go(AppRoutes.lobby);
    }
  }
}

class _OutlineAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final PumpPalette palette;
  final VoidCallback onTap;

  const _OutlineAction({
    required this.icon,
    required this.label,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label.tr(), textAlign: TextAlign.center),
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.foreground,
        side: BorderSide(color: palette.border),
        minimumSize: const Size.fromHeight(48),
        textStyle: PumpTextStyles.label(palette.foreground),
        shape: const StadiumBorder(),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final String machine;
  final int weight;
  final int reps;
  final int loggedSets;
  final int setLimit;
  final PumpPalette palette;
  final ValueChanged<int> onWeightChanged;
  final ValueChanged<int> onRepsChanged;
  final VoidCallback onLogSet;

  const _ExerciseCard({
    required this.machine,
    required this.weight,
    required this.reps,
    required this.loggedSets,
    required this.setLimit,
    required this.palette,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onLogSet,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Container(
      padding: const EdgeInsets.all(PumpSpacing.md),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '{machine} — Set {current} / {total}'.tr(namedArgs: {
                    'machine': machine,
                    'current': '${loggedSets + 1}',
                    'total': '$setLimit',
                  }),
                  style: PumpTextStyles.bodyMd(p.foreground)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: p.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(sessionDefaultSeatPinDummyData,
                    style: PumpTextStyles.label(p.mutedForeground)),
              ),
            ],
          ),
          const SizedBox(height: PumpSpacing.md),
          Row(
            children: [
              Expanded(
                child: _CounterTile(
                  label: 'WEIGHT (LBS)'.tr(),
                  value: '$weight',
                  minus: () => onWeightChanged(-5),
                  plus: () => onWeightChanged(5),
                  palette: p,
                ),
              ),
              const SizedBox(width: PumpSpacing.sm),
              Expanded(
                child: _CounterTile(
                  label: 'REPS'.tr(),
                  value: '$reps',
                  minus: () => onRepsChanged(-1),
                  plus: () => onRepsChanged(1),
                  palette: p,
                ),
              ),
            ],
          ),
          const SizedBox(height: PumpSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: loggedSets < setLimit ? onLogSet : null,
              icon: const Icon(Icons.check, size: 16),
              label: Text('LOG SET'.tr()),
              style: FilledButton.styleFrom(
                backgroundColor: p.primary,
                foregroundColor: p.primaryForeground,
                minimumSize: const Size.fromHeight(42),
              ),
            ),
          ),
          const SizedBox(height: PumpSpacing.sm),
          for (var set = 0; set < setLimit; set++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Set {set} — {status}'.tr(namedArgs: {
                        'set': '${set + 1}',
                        'status':
                            (set < loggedSets ? 'completed' : 'pending').tr(),
                      }),
                      style: PumpTextStyles.bodySm(p.mutedForeground),
                    ),
                  ),
                  Icon(
                    set < loggedSets
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 17,
                    color: set < loggedSets ? p.primary : p.mutedForeground,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CounterTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback minus;
  final VoidCallback plus;
  final PumpPalette palette;

  const _CounterTile({
    required this.label,
    required this.value,
    required this.minus,
    required this.plus,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: palette.secondary,
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      child: Column(
        children: [
          Text(label.tr(),
              style: PumpTextStyles.label(palette.mutedForeground)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TinyControl(label: '-', onTap: minus, palette: palette),
              Text(
                value,
                style: PumpTextStyles.bodyLg(palette.foreground)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              _TinyControl(label: '+', onTap: plus, palette: palette),
            ],
          ),
        ],
      ),
    );
  }
}

class _TinyControl extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final PumpPalette palette;

  const _TinyControl({
    required this.label,
    required this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(PumpRadius.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child:
            Text(label, style: PumpTextStyles.label(palette.mutedForeground)),
      ),
    );
  }
}

class _AddedMachineCard extends StatelessWidget {
  final String machine;
  final PumpPalette palette;

  const _AddedMachineCard({required this.machine, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PumpSpacing.lg),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(PumpRadius.card),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '{machine} — Set 1 / {total}'.tr(namedArgs: {
                'machine': machine,
                'total': '$sessionDefaultSetTargetDummyData',
              }),
              style: PumpTextStyles.bodyMd(palette.foreground),
            ),
          ),
          Icon(Icons.add_circle_outline, color: palette.primary),
        ],
      ),
    );
  }
}

class _MachinePicker extends StatelessWidget {
  final String title;
  final List<String> options;

  const _MachinePicker({required this.title, required this.options});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(PumpSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.tr(), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: PumpSpacing.md),
            for (final option in options)
              ListTile(
                title: Text(option.tr()),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pop(context, option),
              ),
          ],
        ),
      ),
    );
  }
}
