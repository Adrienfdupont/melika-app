import 'package:flutter/cupertino.dart';
import 'package:melika/word.dart';

class WordSection extends StatelessWidget {
  final Word word;

  const WordSection({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Color(0xFFE0E0E0)),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.top,
        children: [
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      word.matchedWord,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(word.pronunciations.join(', '),
                        style: const TextStyle(fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(word.definitions.join(', ')),
              )
            ],
          ),
        ],
      ),
    );
  }
}
