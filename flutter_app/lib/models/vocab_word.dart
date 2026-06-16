class VocabWord {
  final String id;
  final String word;
  final String meaning;
  final String translation;

  const VocabWord({
    required this.id,
    required this.word,
    required this.meaning,
    required this.translation,
  });

  VocabWord updateWord(String? word, String? meaning, String? translation) =>
      VocabWord(
        id: id,
        word: word ?? this.word,
        meaning: meaning ?? this.meaning,
        translation: translation ?? this.translation,
      );

  factory VocabWord.fromJson(Map<String, dynamic> json) {
    return VocabWord(
      id: json['id'] as String,
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      translation: json['translation'] as String,
    );
  }
}
