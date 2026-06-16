import 'package:flutter/material.dart';
import 'package:flutter_app/models/vocab_word.dart';
import 'package:flutter_app/ui/home/widget/info_row.dart';

class WordCard extends StatelessWidget {
  final VocabWord word;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const WordCard({
    super.key,
    required this.word,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    word.word,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            InfoRow(label: 'Meaning', value: word.meaning),
            const SizedBox(height: 4),
            InfoRow(label: 'Translation', value: word.translation),
          ],
        ),
      ),
    );
  }
}
