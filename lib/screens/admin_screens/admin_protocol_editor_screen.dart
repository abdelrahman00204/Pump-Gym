import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/dummy_data/admin_protocol_dummy_data.dart';
import 'package:pump_gym/features/providers/admin_protocol_provider.dart';
import 'package:pump_gym/theme/pump_colors.dart';
import 'package:pump_gym/theme/theme_provider.dart';

Future<void> showAdminProtocolEditor(
  BuildContext context,
  WidgetRef ref, {
  AdminProtocol? protocol,
}) async {
  final result = await showDialog<_EditorResult>(
    context: context,
    builder: (context) => _AdminProtocolEditorDialog(protocol: protocol),
  );

  if (result == null) return;
  if (result.removeId != null) {
    ref.read(adminProtocolsProvider.notifier).remove(result.removeId!);
  } else if (result.protocol != null) {
    ref.read(adminProtocolsProvider.notifier).save(result.protocol!);
  }
}

class _EditorResult {
  final AdminProtocol? protocol;
  final String? removeId;

  const _EditorResult.save(this.protocol) : removeId = null;
  const _EditorResult.remove(this.removeId) : protocol = null;
}

class _AdminProtocolEditorDialog extends ConsumerStatefulWidget {
  final AdminProtocol? protocol;

  const _AdminProtocolEditorDialog({this.protocol});

  @override
  ConsumerState<_AdminProtocolEditorDialog> createState() =>
      _AdminProtocolEditorDialogState();
}

class _AdminProtocolEditorDialogState
    extends ConsumerState<_AdminProtocolEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _coachController;
  late final TextEditingController _priceController;
  late final TextEditingController _expectedGainController;
  late final TextEditingController _durationController;
  late final List<_EditableDay> _days;
  late String _category;
  late String _difficulty;
  var _selectedDayIndex = 0;

  bool get _isEditing => widget.protocol != null;
  _EditableDay get _selectedDay => _days[_selectedDayIndex];

  @override
  void initState() {
    super.initState();
    final protocol = widget.protocol;
    _titleController = TextEditingController(text: protocol?.title);
    _coachController = TextEditingController(text: protocol?.coach);
    _priceController = TextEditingController(text: protocol?.price);
    _expectedGainController =
        TextEditingController(text: protocol?.expectedGain);
    _durationController = TextEditingController(
      text: (protocol?.durationDays ?? 30).toString(),
    );
    _category = protocol?.category ?? adminProtocolCategoriesDummyData.first;
    _difficulty = protocol?.difficulty ?? adminProtocolDifficultiesDummyData[1];
    _days = (protocol?.days ?? adminProtocolDefaultDaysDummyData)
        .map(_EditableDay.fromDay)
        .toList();
    _ensureDurationDays();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _coachController.dispose();
    _priceController.dispose();
    _expectedGainController.dispose();
    _durationController.dispose();
    for (final day in _days) {
      day.dispose();
    }
    super.dispose();
  }

  void _ensureDurationDays() {
    final parsedDuration = int.tryParse(_durationController.text);
    if (parsedDuration == null || parsedDuration < 1) return;
    while (_days.length < parsedDuration) {
      _days.add(
        _EditableDay(label: 'Rest Day', intensity: 'Rest', exercises: []),
      );
    }
    while (_days.length > parsedDuration) {
      _days.removeLast().dispose();
    }
    if (_selectedDayIndex >= _days.length) {
      _selectedDayIndex = _days.length - 1;
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _ensureDurationDays();
    final protocol = AdminProtocol(
      id: widget.protocol?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      coach: _coachController.text.trim(),
      category: _category,
      price: _priceController.text.trim(),
      difficulty: _difficulty,
      expectedGain: _expectedGainController.text.trim(),
      durationDays: int.parse(_durationController.text.trim()),
      days: List.unmodifiable(_days.map((day) => day.toDay())),
    );
    Navigator.of(context).pop(_EditorResult.save(protocol));
  }

  void _remove() {
    Navigator.of(context).pop(_EditorResult.remove(widget.protocol!.id));
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(pumpPaletteProvider);
    final textTheme = Theme.of(context).textTheme;
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: p.secondary,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: p.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: p.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: p.primary),
      ),
    );
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: p.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: p.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 850),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      (_isEditing ? 'EDIT PROTOCOL' : 'NEW PROTOCOL').tr(),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: p.primary,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close'.tr(),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: p.border),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final twoColumns = constraints.maxWidth > 520;
                        return _FieldGrid(
                          twoColumns: twoColumns,
                          children: [
                            _textField(
                              label: 'TITLE *',
                              controller: _titleController,
                              decoration: inputDecoration,
                            ),
                            _textField(
                              label: 'COACH *',
                              controller: _coachController,
                              decoration: inputDecoration,
                            ),
                            _dropdown(
                              label: 'CATEGORY *',
                              value: _category,
                              options: adminProtocolCategoriesDummyData,
                              decoration: inputDecoration,
                              onChanged: (value) =>
                                  setState(() => _category = value),
                            ),
                            _textField(
                              label: 'PRICE (\$) *',
                              controller: _priceController,
                              decoration: inputDecoration,
                              keyboardType: TextInputType.number,
                              validator: _requiredNumber,
                            ),
                            _dropdown(
                              label: 'DIFFICULTY *',
                              value: _difficulty,
                              options: adminProtocolDifficultiesDummyData,
                              decoration: inputDecoration,
                              onChanged: (value) =>
                                  setState(() => _difficulty = value),
                            ),
                            _textField(
                              label: 'EXPECTED GAIN *',
                              controller: _expectedGainController,
                              decoration: inputDecoration,
                            ),
                            _textField(
                              label: 'DURATION (DAYS) *',
                              controller: _durationController,
                              decoration: inputDecoration,
                              keyboardType: TextInputType.number,
                              validator: _requiredInteger,
                              onChanged: (_) => setState(_ensureDurationDays),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    _sectionLabel(
                      'DAY-BY-DAY PROGRAM — WEEK 1 OF {days}'.tr(
                        namedArgs: {'days': '${_days.length}'},
                      ),
                      p.mutedForeground,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _days.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 6),
                        itemBuilder: (context, index) {
                          final selected = index == _selectedDayIndex;
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () =>
                                setState(() => _selectedDayIndex = index),
                            child: Container(
                              width: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selected ? p.primary : p.secondary,
                                border: Border.all(color: p.border),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: selected
                                      ? p.primaryForeground
                                      : p.foreground,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    LayoutBuilder(
                      builder: (context, constraints) => _FieldGrid(
                        twoColumns: constraints.maxWidth > 520,
                        children: [
                          _textField(
                            label: 'DAY LABEL',
                            controller: _selectedDay.labelController,
                            decoration: inputDecoration,
                          ),
                          _dropdown(
                            label: 'INTENSITY',
                            value: _selectedDay.intensity,
                            options: adminProtocolIntensitiesDummyData,
                            decoration: inputDecoration,
                            onChanged: (value) => setState(
                              () => _selectedDay.intensity = value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _sectionLabel(
                      'MACHINES — WEEK 1'.tr(),
                      p.mutedForeground,
                    ),
                    const SizedBox(height: 8),
                    for (var index = 0;
                        index < _selectedDay.exercises.length;
                        index++)
                      _exerciseCard(
                        index,
                        p,
                        inputDecoration,
                        twoColumns: MediaQuery.sizeOf(context).width > 600,
                      ),
                    OutlinedButton.icon(
                      onPressed: _addExercise,
                      icon: const Icon(Icons.add, size: 16),
                      label: Text(
                        'ADD MACHINE TO DAY {day}'.tr(
                          namedArgs: {'day': '${_selectedDayIndex + 1}'},
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: p.foreground,
                        side: BorderSide(color: p.border),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: p.border),
            Padding(
              padding: const EdgeInsets.all(14),
              child: _isEditing
                  ? LayoutBuilder(
                      builder: (context, constraints) {
                        final narrow = constraints.maxWidth < 420;
                        final removeButton = OutlinedButton.icon(
                          onPressed: _remove,
                          icon: const Icon(Icons.delete_outline),
                          label: Text('REMOVE PLAN'.tr()),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: p.destructive,
                            side: BorderSide(color: p.border),
                            minimumSize: const Size(0, 44),
                          ),
                        );
                        final saveButton = ElevatedButton.icon(
                          onPressed: _save,
                          icon: const Icon(Icons.check),
                          label: Text('SAVE PROTOCOL'.tr()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: p.primary,
                            foregroundColor: p.primaryForeground,
                            minimumSize: const Size(0, 44),
                          ),
                        );
                        return narrow
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  removeButton,
                                  const SizedBox(height: 8),
                                  saveButton,
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(child: removeButton),
                                  const SizedBox(width: 10),
                                  Expanded(child: saveButton),
                                ],
                              );
                      },
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.check),
                        label: Text('SAVE PROTOCOL'.tr()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.primary,
                          foregroundColor: p.primaryForeground,
                          minimumSize: const Size(0, 44),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    required InputDecoration decoration,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: decoration,
          validator: validator ?? _requiredText,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> options,
    required InputDecoration decoration,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: decoration,
          dropdownColor: Theme.of(context).colorScheme.surface,
          items: options
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option.tr()),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ],
    );
  }

  Widget _exerciseCard(
    int index,
    PumpPalette p,
    InputDecoration decoration, {
    required bool twoColumns,
  }) {
    final exercise = _selectedDay.exercises[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: p.secondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: exercise.machine,
                  decoration: decoration,
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  items: adminProtocolMachinesDummyData
                      .map((machine) => DropdownMenuItem(
                            value: machine,
                            child: Text(
                              machine,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => exercise.machine = value);
                    }
                  },
                ),
              ),
              IconButton(
                tooltip: 'Remove machine'.tr(),
                onPressed: () => setState(
                  () => _selectedDay.exercises.removeAt(index).dispose(),
                ),
                icon: Icon(
                  Icons.delete_outline,
                  color: p.mutedForeground,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _FieldGrid(
            twoColumns: twoColumns,
            compact: true,
            children: [
              _exerciseField('SETS', exercise.setsController, decoration),
              _exerciseField(
                'REPS',
                exercise.repsController,
                decoration,
                validator: _requiredText,
              ),
              _exerciseField(
                  'WEIGHT (LBS)', exercise.weightController, decoration),
              _exerciseField(
                'REST (S)',
                exercise.restSecondsController,
                decoration,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _exerciseField(
    String label,
    TextEditingController controller,
    InputDecoration decoration, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: decoration,
          validator: validator ?? _requiredNumber,
        ),
      ],
    );
  }

  Widget _sectionLabel(String text, Color color) => Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.3,
        ),
      );

  Widget _fieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 5, top: 10),
        child: Text(
          text.tr(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      );

  String? _requiredText(String? value) =>
      value == null || value.trim().isEmpty ? 'Required'.tr() : null;

  String? _requiredNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required'.tr();
    if (num.tryParse(value.trim()) == null) return 'Enter a number'.tr();
    return null;
  }

  String? _requiredInteger(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required'.tr();
    final number = int.tryParse(value.trim());
    if (number == null || number < 1) {
      return 'Enter a whole number above 0'.tr();
    }
    return null;
  }

  void _addExercise() {
    setState(() {
      _selectedDay.exercises.add(
        _EditableExercise(
          machine: adminProtocolMachinesDummyData.first,
          sets: '3',
          reps: '8–12',
          weight: '0',
          restSeconds: '90',
        ),
      );
    });
  }
}

class _FieldGrid extends StatelessWidget {
  final bool twoColumns;
  final bool compact;
  final List<Widget> children;

  const _FieldGrid({
    required this.twoColumns,
    required this.children,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!twoColumns) {
      return Column(
        children: [
          for (final child in children)
            Padding(
              padding: EdgeInsets.only(bottom: compact ? 4 : 2),
              child: child,
            ),
        ],
      );
    }

    final rows = <Widget>[];
    for (var index = 0; index < children.length; index += 2) {
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: compact ? 4 : 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: children[index]),
              const SizedBox(width: 12),
              if (index + 1 < children.length)
                Expanded(child: children[index + 1])
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _EditableDay {
  final TextEditingController labelController;
  String intensity;
  final List<_EditableExercise> exercises;

  _EditableDay({
    required String label,
    required this.intensity,
    required this.exercises,
  }) : labelController = TextEditingController(text: label);

  factory _EditableDay.fromDay(AdminProtocolDay day) => _EditableDay(
        label: day.label,
        intensity: day.intensity,
        exercises: day.exercises.map(_EditableExercise.fromExercise).toList(),
      );

  AdminProtocolDay toDay() => AdminProtocolDay(
        label: labelController.text.trim(),
        intensity: intensity,
        exercises:
            List.unmodifiable(exercises.map((item) => item.toExercise())),
      );

  void dispose() {
    labelController.dispose();
    for (final exercise in exercises) {
      exercise.dispose();
    }
  }
}

class _EditableExercise {
  String machine;
  final TextEditingController setsController;
  final TextEditingController repsController;
  final TextEditingController weightController;
  final TextEditingController restSecondsController;

  _EditableExercise({
    required this.machine,
    required String sets,
    required String reps,
    required String weight,
    required String restSeconds,
  })  : setsController = TextEditingController(text: sets),
        repsController = TextEditingController(text: reps),
        weightController = TextEditingController(text: weight),
        restSecondsController = TextEditingController(text: restSeconds);

  factory _EditableExercise.fromExercise(AdminProtocolExercise exercise) =>
      _EditableExercise(
        machine: exercise.machine,
        sets: exercise.sets,
        reps: exercise.reps,
        weight: exercise.weight,
        restSeconds: exercise.restSeconds,
      );

  AdminProtocolExercise toExercise() => AdminProtocolExercise(
        machine: machine,
        sets: setsController.text.trim(),
        reps: repsController.text.trim(),
        weight: weightController.text.trim(),
        restSeconds: restSecondsController.text.trim(),
      );

  void dispose() {
    setsController.dispose();
    repsController.dispose();
    weightController.dispose();
    restSecondsController.dispose();
  }
}
