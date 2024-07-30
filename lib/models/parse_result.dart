import 'package:arkham_parse/models/parse_error.dart';
import 'package:arkham_parse/models/statistic.dart';

class ParseResult {
  final ParseError? error;
  final Statistic? statistic;

  ParseResult({
    this.error,
    this.statistic,
  });
}