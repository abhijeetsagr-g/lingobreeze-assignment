import 'package:flutter_app/models/vocab_word.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VocabWord', () {
    test('fromJson creates correct instance', () {
      final json = {
        'id': 'abc123',
        'word': 'Apple',
        'meaning': 'A fruit',
        'translation': 'Manzana',
      };

      final word = VocabWord.fromJson(json);

      expect(word.id, 'abc123');
      expect(word.word, 'Apple');
      expect(word.meaning, 'A fruit');
      expect(word.translation, 'Manzana');
    });

    test('updateWord returns new instance with overrides', () {
      final word = VocabWord(
        id: 'abc123',
        word: 'Apple',
        meaning: 'A fruit',
        translation: 'Manzana',
      );

      final updated = word.updateWord('Apple', 'A sweet fruit', null);

      expect(updated.id, 'abc123');
      expect(updated.word, 'Apple');
      expect(updated.meaning, 'A sweet fruit');
      expect(updated.translation, 'Manzana');
      expect(identical(word, updated), false);
    });

    test('updateWord keeps existing values when null', () {
      final word = VocabWord(
        id: 'abc123',
        word: 'Apple',
        meaning: 'A fruit',
        translation: 'Manzana',
      );

      final updated = word.updateWord(null, null, null);

      expect(updated.word, 'Apple');
      expect(updated.meaning, 'A fruit');
      expect(updated.translation, 'Manzana');
    });
  });
}
