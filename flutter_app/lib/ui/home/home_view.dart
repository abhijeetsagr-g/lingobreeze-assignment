import 'package:flutter/material.dart';
import 'package:flutter_app/models/vocab_word.dart';
import 'package:flutter_app/riverpod/providers.dart';
import 'package:flutter_app/ui/dialog/add_word_dialog.dart';
import 'package:flutter_app/ui/home/widget/home_empty_state.dart';
import 'package:flutter_app/ui/home/widget/home_filled_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  void _openAddDialog(BuildContext context, WidgetRef ref) {
    AddWordDialog.show(
      context,
      onSave: (word, meaning, translation) async {
        try {
          final service = ref.read(wordsServiceProvider);
          await service.addWord(
            word: word,
            meaning: meaning,
            translation: translation,
          );
          ref.invalidate(wordsProvider);
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save word: $e')),
          );
        }
      },
    );
  }

  void _openEditDialog(BuildContext context, WidgetRef ref, VocabWord word) {
    AddWordDialog.show(
      context,
      initial: word,
      onSave: (newWord, meaning, translation) async {
        try {
          final service = ref.read(wordsServiceProvider);
          await service.updateWord(
            word: VocabWord(
              id: word.id,
              word: newWord,
              meaning: meaning,
              translation: translation,
            ),
          );
          ref.invalidate(wordsProvider);
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update word: $e')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAsync = ref.watch(wordsProvider);

    return Scaffold(
      body: SafeArea(
        child: wordsAsync.when(
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Something went wrong'),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => ref.invalidate(wordsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          data: (words) => words.isEmpty
              ? HomeEmptyState(onAddWord: () => _openAddDialog(context, ref))
              : HomeFilledState(
                  words: words,
                  onEdit: (word) => _openEditDialog(context, ref, word),
                  onDelete: (id) async {
                    try {
                      final service = ref.read(wordsServiceProvider);
                      await service.deleteWord(id);
                      ref.invalidate(wordsProvider);
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete: $e')),
                      );
                    }
                  },
                ),
        ),
      ),
      floatingActionButton: wordsAsync.maybeWhen(
        data: (words) => words.isNotEmpty
            ? FloatingActionButton(
                onPressed: () => _openAddDialog(context, ref),
                child: const Icon(Icons.add),
              )
            : null,
        orElse: () => null,
      ),
    );
  }
}
