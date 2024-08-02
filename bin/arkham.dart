import 'dart:io';

import 'package:args/args.dart';
import 'package:arkham/parser.dart';
import 'package:date_format/date_format.dart';

void main(List<String> args) {
  var parser = ArgParser();
  parser.addOption('input', defaultsTo: 'arkham.txt');
  parser.addOption('output', defaultsTo: 'statistic.csv');
  parser.addOption('min_cost_coins');

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

  final statisticCsv = File(output!);

  if (!statisticCsv.existsSync()) {
    // добавляем колонки в пустой файл
    statisticCsv.writeAsStringSync(
      'Coin, Current Count, Date\n',
      mode: FileMode.append,
    );
  }

  final formattedTodayDate = formatDate(
    DateTime.now(),
    [dd, '-', mm, '-', yyyy],
  );

  // записываем значения для cvs
  for (final coin in statistic.coins) {
    if (minCostCoins != null && coin.cost < minCostCoins) {
      continue;
    }
    statisticCsv.writeAsStringSync(
      '${coin.name}, ${coin.currentValue}, $formattedTodayDate\n',
      mode: FileMode.append,
    );
  }

  // сохраняем в файле
  await statisticCsv.create();
  stdout.writeln('CSV successfully created!! Placed in "$output"');
}
