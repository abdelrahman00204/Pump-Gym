import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump_gym/features/providers/admin_walk_in_provider.dart';
import 'package:pump_gym/theme/theme_provider.dart';

Future<void> showAdminAddVisitorDialog(
  BuildContext context,
  WidgetRef ref,
) {
  return showDialog<void>(
    context: context,
    builder: (context) => _AdminAddVisitorDialog(onAdd: (name) {
      ref.read(adminWalkInRecordsProvider.notifier).addVisitor(name);
    }),
  );
}

class _AdminAddVisitorDialog extends StatefulWidget {
  final ValueChanged<String> onAdd;

  const _AdminAddVisitorDialog({required this.onAdd});

  @override
  State<_AdminAddVisitorDialog> createState() => _AdminAddVisitorDialogState();
}

class _AdminAddVisitorDialogState extends State<_AdminAddVisitorDialog> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _add() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAdd(_nameController.text.trim());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final p = ProviderScope.containerOf(context).read(pumpPaletteProvider);
    return Dialog(
      backgroundColor: p.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: p.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'ADD ONE-TIME VISITOR'.tr(),
                      style: TextStyle(
                        color: p.foreground,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
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
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: "Visitor's name...".tr(),
                  filled: true,
                  fillColor: p.secondary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: p.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: p.primary),
                  ),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a visitor name'.tr()
                    : null,
                onFieldSubmitted: (_) => _add(),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _add,
                  icon: const Icon(Icons.person_add_alt_1),
                  label: Text('ADD VISITOR'.tr()),
                  style: FilledButton.styleFrom(
                    backgroundColor: p.primary,
                    foregroundColor: p.primaryForeground,
                    minimumSize: const Size(0, 44),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
