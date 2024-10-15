import 'package:melika/word.dart';

class SearchResult {
  final String translation;
  final List<Word> words;

  SearchResult(this.translation, this.words);

  void addWord(Word word) {
    words.add(word);
  }
}