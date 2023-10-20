//Copyright 2022 Crazy Mind
///HTML Parsing Code

import 'package:html/parser.dart';

/// The parserHtml function is for parsing html into plain string.
class ParserHtml {
  String parserHtml(String input) {
    final document = parse(input);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}
