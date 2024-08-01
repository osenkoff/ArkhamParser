import 'package:beautiful_soup_dart/beautiful_soup.dart';

import '../models/statistic.dart';

class ArkhamParse {
  final String file;

  ArkhamParse({required this.file});

  Future<Statistic> parseStatistic() async {
    BeautifulSoup soup = BeautifulSoup(file);

    final assetsColumns = soup
        .findAll('div', class_: 'TimeMachine_portfolioGrid__MTxZX')
        .toList();
    final coin = soup
        .findAll('a', class_: 'TimeMachine_start__BDapq')
        .map((elem) => elem.text ?? '')
        .toSet()
        .toList();
    final previousValue = assetsColumns[0]
        .findAll('div', class_: 'TimeMachine_holdingsAmount__Td8Wg')
        .map((elem) => elem.text)
        .toList();
    final currentValue = assetsColumns[1]
        .findAll('div', class_: 'TimeMachine_holdingsAmount__Td8Wg')
        .map((elem) => elem.text)
        .toList();

    return Statistic(
      coin: coin,
      previousValue: previousValue,
      currentValue: currentValue,
    );
  }
}
