library parser;

import 'dart:async';
import 'dart:io';

import 'package:arkham_parse/parsers/arkham_parse.dart';

import 'models/parse_error.dart';
import 'models/parse_result.dart';

void main() async {
  final file = await File(
          'C:/Users/osenk/Desktop/Dart Practice/test_page/lib/arkham.txt')
      .readAsString();
  final result = await Parser(file: file).parse();
  final statisticCsv = File('statistic.csv');

  if (result.statistic != null) {
    final statistic = result.statistic!;

    statisticCsv.writeAsStringSync('${'Coin'}, ${'Previous'}, ${'Current'}\n', mode: FileMode.append);
    for (var i = 0; i < statistic.coin.length; i++) {
      statisticCsv.writeAsStringSync('${statistic.coin[i]}, ${statistic.previousValue[i]}, ${statistic.currentValue[i]}\n', mode: FileMode.append);
    }
    statisticCsv.create();
    print('CSV File successfully created!!');
  } else {
    print(result.error?.title);
    print(result.error?.content);
  }
}

class Parser {
  final String file;

  Parser({required this.file});

  Future<ParseResult> parse() async {
    try {
      if (file.isNotEmpty) {
        return ParseResult(
            statistic: await ArkhamParse(
          file: file,
        ).parseStatistic());
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
