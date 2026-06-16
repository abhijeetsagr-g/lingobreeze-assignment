import 'package:flutter_app/models/vocab_word.dart';
import 'package:flutter_app/services/words_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wordsServiceProvider = Provider<WordsService>((ref) {
  // Using local address
  return WordsService(apiBaseUrl: 'http://192.168.1.17:3000');
});

final wordsProvider = AsyncNotifierProvider<WordsNotifier, List<VocabWord>>(
  WordsNotifier.new,
);

class WordsNotifier extends AsyncNotifier<List<VocabWord>> {
  @override
  Future<List<VocabWord>> build() async {
    final service = ref.read(wordsServiceProvider);
    return service.fetchWords();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final service = ref.read(wordsServiceProvider);
      return service.fetchWords();
    });
  }
}
