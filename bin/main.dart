import 'dart:io';

import 'package:args/args.dart';
import 'package:arkham/parser.dart';

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
  final file = File(input!);

  if (!file.existsSync()) {
    throw Exception('File is not exist. Need to pass the file');
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
      'Coin, Previous, Current\n',
      mode: FileMode.append,
    );
  }

  for (final coin in statistic.coins) {
    statisticCsv.writeAsStringSync(
      '${coin.name}, ${coin.previousValue}, ${coin.currentValue}\n',
      mode: FileMode.append,
    );
  }

  await statisticCsv.create();
  stdout.writeln('CSV successfully created!! Placed in "$output"');
}
