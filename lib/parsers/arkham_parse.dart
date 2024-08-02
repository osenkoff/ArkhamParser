import 'package:beautiful_soup_dart/beautiful_soup.dart';

import '../models/statistic.dart';

class ArkhamParse {
  final String content;

  ArkhamParse({required this.content});

  Future<Statistic?> parseStatistic() async {
    BeautifulSoup soup = BeautifulSoup(content);

    final element = soup.find('', class_: 'TimeMachine_desktopHeader');

    if (element == null) {
      return null;
    }

    final assetsColumns =
        element.findAll('div', class_: 'TimeMachine_portfolioGrid').toList();
    final coinNames = assetsColumns[0]
        .findAll('a', class_: 'TimeMachine_start')
        .map((elem) => elem.text)
        .toSet()
        .toList();
    final currentValue = assetsColumns[1]
        .findAll('div', class_: 'TimeMachine_holdingsAmount')
        .map((elem) => elem.text)
        .toList();
    final costs = assetsColumns[1]
        .findAll('div', class_: 'TimeMachine_holdings')
        .map((elem) {
      final costValue =
          elem.find('span', class_: 'TimeMachine_numberWithIndicator')?.text ??
              '0';

      return _getCostValue(costValue);
    }).toList();

    final coins = <Coin>[];

    for (var i = 0; i < coinNames.length; i++) {
      final name = coinNames[i];
      final current = currentValue[i];
      final cost = costs[i];

      coins.add(
        Coin(
          name: name,
          currentValue: current,
          cost: cost,
        ),
      );
    }

    return Statistic(
      coins: coins,
    );
  }

  double _getCostValue(String cost) {
    final normalizedCost =
        double.tryParse(cost.replaceAll(RegExp(r"[^.0-9]"), '')) ?? 0;
    if (cost.contains('M')) {
      return normalizedCost * 1000000;
    }
    if (cost.contains('K')) {
      return normalizedCost * 1000;
    }
    return normalizedCost;
  }
}
