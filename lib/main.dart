import 'dart:io';

import 'package:arkham/parser.dart';

import 'models/statistic.dart';

void main() async {
  // only for test
  final file = File('bin/arkham.txt');
  final content = file.readAsStringSync();

  final result = await Parser(content).parse();

  const minCostCoins = 0;

  for (final coin in result.statistic?.coins ?? <Coin>[]) {
    if (coin.cost < minCostCoins) {
      continue;
    }

    print('${coin.name} ${coin.previousValue} ${coin.currentValue} ${coin.cost}');
  }
}

