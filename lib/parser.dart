library parser;

import 'dart:async';

import 'parsers/arkham_parse.dart';

import 'models/parse_error.dart';
import 'models/parse_result.dart';

class Parser {
  final String content;

  Parser(this.content);

  Future<ParseResult> parse() async {
    try {
      if (content.isNotEmpty) {
        return ParseResult(
          statistic: await ArkhamParse(content: content).parseStatistic(),
        );
      } else {
        return ParseResult(
          error: ParseError(
            title: 'Невозможно получить данные.',
            content: 'Попробуйте позже.',
          ),
        );
      }
    } catch (e) {
      return ParseResult(
        error: ParseError(
          title: e.toString(),
          content: 'Попробуйте позже.',
        ),
      );
    }
  }
}
