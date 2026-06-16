import 'package:flutter/material.dart';
import 'package:flutter_app/models/vocab_word.dart';
import 'package:flutter_app/ui/dialog/word_field.dart';

class AddWordDialog extends StatefulWidget {
  final Future<void> Function(String word, String meaning, String translation)
  onSave;
  final VocabWord? initial;

  const AddWordDialog({super.key, required this.onSave, this.initial});

  static Future<void> show(
    BuildContext context, {
    required Future<void> Function(
      String word,
      String meaning,
      String translation,
    )
    onSave,
    VocabWord? initial,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AddWordDialog(onSave: onSave, initial: initial),
    );
  }

  @override
  State<AddWordDialog> createState() => _AddWordDialogState();
}

class _AddWordDialogState extends State<AddWordDialog> {
  late final _wordController = TextEditingController(
    text: widget.initial?.word ?? '',
  );
  late final _meaningController = TextEditingController(
    text: widget.initial?.meaning ?? '',
  );
  late final _translationController = TextEditingController(
    text: widget.initial?.translation ?? '',
  );
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await widget.onSave(
        _wordController.text.trim(),
        _meaningController.text.trim(),
        _translationController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initial != null ? 'Edit word' : 'Add new word',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFF1F0FA),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFF888780),
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              WordField(
                label: 'WORD',
                icon: Icons.text_fields_rounded,
                controller: _wordController,
                hint: 'e.g. Apple',
              ),
              const SizedBox(height: 14),
              WordField(
                label: 'MEANING',
                icon: Icons.info_outline_rounded,
                controller: _meaningController,
                hint: 'e.g. A round fruit',
              ),
              const SizedBox(height: 14),
              WordField(
                label: 'TRANSLATION',
                icon: Icons.translate_rounded,
                controller: _translationController,
                hint: 'e.g. Manzana',
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF888780),
                          side: const BorderSide(color: Color(0xFF3A3A42)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.check_rounded, size: 16),
                        label: const Text('Save word'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF534AB7),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
