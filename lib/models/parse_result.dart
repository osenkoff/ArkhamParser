import 'package:arkham/models/parse_error.dart';
import 'package:arkham/models/statistic.dart';

class ParseResult {
  final ParseError? error;
  final Statistic? statistic;

  ParseResult({
    this.error,
    this.statistic,
  });
}