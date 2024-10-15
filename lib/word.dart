import 'package:html/parser.dart';

class Word {
  final String matchedWord;
  final String responseBody;
  final List<String> pronunciations = [];
  final List<String> definitions = [];

  Word(this.matchedWord, this.responseBody) {
    extractData();
  }

  void extractData() {
    var document = parse(responseBody);
    var sectionTitle = document.getElementById('Persian')?.parent;
    var definitionsFound = false;

    var nextElement = sectionTitle?.nextElementSibling;
    while (nextElement != null) {
      // find pronunciation table
      if (nextElement.localName == 'p' &&
          nextElement.firstChild?.attributes['class'] == 'headword-line' &&
          pronunciations.isEmpty) {
        var headwordLine = nextElement.firstChild;
        if (headwordLine != null) {
          for (var child in headwordLine.children) {
            var className = child.attributes['class'];
            if (className != null && className.contains('headword-tr')) {
              pronunciations.add(child.text);
            }
          }
        }
      }

      // find definitions
      if (nextElement.localName == 'ol') {
        var listItems = nextElement.getElementsByTagName('li');
        for (var item in listItems) {
          for (var child in item.children) {
            // if (child.localName == 'a' &&
            //     definitions.contains(child.text) == false) {
            //   definitions.add(child.text);
            // }
            if (child.localName != 'dl' && definitionsFound == false) {
              definitions.add(child.text);
            }
            definitionsFound = true;
          }
        }
      }

      // stop if next language section is reached
      if (nextElement.attributes['class'] != 'mw-heading mw-heading2') {
        nextElement = nextElement.nextElementSibling;
      } else {
        break;
      }
    }
  }
}
