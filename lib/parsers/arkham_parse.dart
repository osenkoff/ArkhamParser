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
        .toList();
    final previousValue = assetsColumns[0]
        .findAll('div', class_: 'TimeMachine_holdingsAmount')
        .map((elem) => _normalizeValue(elem.text))
        .toList();
    final currentValue = assetsColumns[1]
        .findAll('div', class_: 'TimeMachine_holdingsAmount')
        .map((elem) => _normalizeValue(elem.text))
        .toList();
    final costs = assetsColumns[1]
        .findAll('div', class_: 'TimeMachine_holdings__')
        .map((elem) {
      final costValue =
          elem.find('span', class_: 'TimeMachine_numberWithIndicator')?.text ??
              '0';

      return _normalizeValue(costValue);
    }).toList();

    final coins = <Coin>[];

    for (var i = 0; i < coinNames.length; i++) {
      final name = coinNames[i];
      final prev = previousValue[i];
      final current = currentValue[i];
      final cost = costs[i];

      coins.add(
        Coin(
          name: name,
          previousValue: prev,
          currentValue: current,
          cost: cost,
        ),
      );
    }

    return Statistic(
      coins: coins,
    );
  }

  double _normalizeValue(String value) {
    final normalizedCost =
        double.tryParse(value.replaceAll(RegExp(r"[^.0-9]"), '')) ?? 0;
    if (value.contains('M')) {
      return normalizedCost * 1000000;
    }
    if (value.contains('K')) {
      return normalizedCost * 1000;
    }
    return normalizedCost;
  }
}
