import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/vocab_word.dart';
import 'package:http/http.dart' as http;

class WordsService {
  final CollectionReference _wordsRef = FirebaseFirestore.instance.collection(
    'words',
  );

  // local address
  final String apiBaseUrl;
  WordsService({required this.apiBaseUrl});

  // Create
  Future<void> addWord({
    required String word,
    required String translation,
    required String meaning,
  }) => _wordsRef.add({
    'word': word,
    'meaning': meaning,
    'translation': translation,
  });

  // Read (using NodeJs backend)
  Future<List<VocabWord>> fetchWords() async {
    final response = await http.get(Uri.parse('$apiBaseUrl/words'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load words (${response.statusCode})');
    }

    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => VocabWord.fromJson(json)).toList();
  }

  // Update
  Future<void> updateWord({required VocabWord word}) =>
      _wordsRef.doc(word.id).update({
        'word': word.word,
        'meaning': word.meaning,
        'translation': word.translation,
      });

  // Delete
  Future<void> deleteWord(String id) => _wordsRef.doc(id).delete();
}
