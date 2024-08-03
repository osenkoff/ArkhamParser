import 'dart:io';

import 'package:args/args.dart';
import 'package:arkham/models/statistic.dart';
import 'package:arkham/parser.dart';
import 'package:csv/csv.dart';
import 'package:date_format/date_format.dart';

void main(List<String> args) {
  var parser = ArgParser();
  parser.addOption('input', defaultsTo: 'arkham.txt');
  parser.addOption('output', defaultsTo: 'statistic.csv');
  parser.addOption('min_cost_coins');
  parser.addFlag('with_delimiter');

  var result = parser.parse(args);

  try {
    _run(result);
  } on Exception catch (e) {
    stdout.writeln('Error: ${e.toString()}');
    return;
  }
}

void _run(ArgResults arguments) async {
  final input = arguments.option('input');
  final output = arguments.option('output');
  final needToAddDelimiter = arguments.flag('with_delimiter');
  final minCostCoinsAsString = arguments.option('min_cost_coins');
  final minCostCoins = minCostCoinsAsString != null
      ? double.tryParse(minCostCoinsAsString)
      : null;

  final file = File(input!);

  if (!file.existsSync()) {
    throw Exception(
      'File is not exist by "$input". Need to set the correct file path',
    );
  }

  final content = await file.readAsString();
  final result = await Parser(content).parse();

  final statistic = result.statistic;

  if (statistic == null) {
    throw Exception(result.error?.title);
  }

  _generateCVS(
    data: statistic,
    outputPath: output!,
    minCostCoins: minCostCoins ?? 0,
    withDelimiter: needToAddDelimiter,
  );

  stdout.writeln('CSV created successfully. Placed in "$output"');
}

void _generateCVS({
  required Statistic data,
  required String outputPath,
  required double minCostCoins,
  bool withDelimiter = false,
}) {
  final statisticCsv = File(outputPath);

  List<List<String>> headerAndDataList = [];

  if (!statisticCsv.existsSync()) {
    // добавляем колонки, если файла нет
    headerAndDataList.add([
      'Coin',
      'Prev. Count',
      'Current Count',
      'Date',
    ]);
  } else if (withDelimiter) {
    headerAndDataList.add([
      '', '', '', '',
    ]);
  }

  final formattedTodayDate = formatDate(
    DateTime.now(),
    [dd, '-', mm, '-', yyyy],
  );

  // формируем значения для cvs
  for (final coin in data.coins) {
    if (coin.cost < minCostCoins) {
      continue;
    }
    headerAndDataList.add([
      coin.name,
      coin.previousValue.toString(),
      coin.currentValue.toString(),
      formattedTodayDate,
    ]);
  }

  String csvData = const ListToCsvConverter().convert(headerAndDataList);

  // записываем данные в файл
  statisticCsv.writeAsStringSync('$csvData\n', mode: FileMode.append);
  // сохраняем файл
  statisticCsv.createSync();
}
