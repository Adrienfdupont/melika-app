import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:melika/search_result.dart';
import 'package:melika/word.dart';
import 'package:melika/word_section.dart';
import 'package:translator/translator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final translator = GoogleTranslator();
  final inputController = TextEditingController();
  Future<SearchResult>? searchResult;

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  Future<SearchResult> search() async {
    final translation =
        await translator.translate(inputController.text, from: 'en', to: 'fa');
    final words = translation.text.split(' ');
    var baseUrl = 'https://en.wiktionary.org/wiki/';
    var searchResult = SearchResult(translation.text, []);
    for (var i = 0; i < words.length; i++) {
      for (var attempts = 0; attempts < 3; attempts++) {
        var searchPattern = words[i].substring(0, words[i].length - attempts);
        final response = await http.get(Uri.parse(baseUrl + searchPattern));
        if (response.statusCode == 200) {
          searchResult.addWord(Word(searchPattern, response.body));
          break;
        }
      }
    }
    return searchResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF14132B),
          toolbarHeight: 0,
        ),
        backgroundColor: const Color(0xFF14132B),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Translate into Persian',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white12),
                    filled: true,
                    fillColor: Color(0xFF1E1C36),
                  ),
                  style: const TextStyle(color: Colors.white),
                  controller: inputController,
                  onSubmitted: (value) {
                    setState(() {
                      searchResult = search();
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: FutureBuilder<SearchResult>(
                  future: searchResult,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data == null) {
                      return const Text(
                        'No results found',
                        style: TextStyle(color: Colors.white),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        'An error occurred.',
                        style: TextStyle(color: Colors.red),
                      );
                    } else {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            color: const Color(0xFF2d2751),
                            child: Text(snapshot.data!.translation,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 24)),
                          ),
                          for (var word in snapshot.data!.words)
                            WordSection(word: word),
                        ],
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
