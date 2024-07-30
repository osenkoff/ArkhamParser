library parser;

import 'dart:async';
import 'dart:io';

import 'package:arkham_parse/parsers/arkham_parse.dart';
import 'package:http/http.dart' as http;

import 'models/parse_error.dart';
import 'models/parse_result.dart';

const arkhamLink = 'https://platform.arkhamintelligence.com/explorer/address/0xD8D6fFE342210057BF4DCc31DA28D006f253cEF0';
const availableDomains = ['https://platform.arkhamintelligence.com/'];

void main(List<String> arguments) async {
  //link takes the value from available const
  //will change to cmd input late
  const link = arkhamLink;
  final result = await Parser(link: link).parse();
  if (result.statistic != null) {
    final statistic = result.statistic!;
    print(statistic.coin);
    print(statistic.previousValue);
  } else {
    print(result.error?.title);
    print(result.error?.content);
  }
}

class Parser {
  final String link;

  Parser({required this.link});

  Future<ParseResult> parse() async {
    if (availableDomains.any((site) => link.contains(site))) {
      try {
        final response = await http.get(Uri.parse(link));
        if (response.statusCode == 200) {
          return ParseResult(
            statistic: await ArkhamParse(
              response: response,
              link: link,
            ).parseStatistic(),
          );
        } else {
          return ParseResult(
            error: ParseError(
              title: 'Unable to fetch data.',
              content: 'Please try again later.',
            ),
          );
        }
      } on TimeoutException catch (_) {
        return ParseResult(
          error: ParseError(
            title: 'Request timed out.',
            content: 'Please try again later.',
          ),
        );
      } catch (e) {
        return ParseResult(
          error: ParseError(
            title: e.toString(),
            content: 'Please try again later.',
          ),
        );
      }
    }
    return ParseResult(
      error: ParseError(
        title: 'No parser available for this site.',
      ),
    );
  }
}
