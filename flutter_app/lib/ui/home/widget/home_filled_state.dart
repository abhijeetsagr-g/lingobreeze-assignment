import 'package:flutter/material.dart';
import 'package:flutter_app/models/vocab_word.dart';
import 'package:flutter_app/ui/home/widget/word_card.dart';

class HomeFilledState extends StatelessWidget {
  final List<VocabWord> words;
  final void Function(String id) onDelete;
  final void Function(VocabWord word) onEdit;

  const HomeFilledState({
    super.key,
    required this.words,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'My Vocabulary',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: words.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final word = words[index];
                return WordCard(
                  word: word,
                  onDelete: () => onDelete(word.id),
                  onEdit: () => onEdit(word),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
