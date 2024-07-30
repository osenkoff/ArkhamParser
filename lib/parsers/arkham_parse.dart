import 'dart:convert';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import "package:http/http.dart";

import '../models/statistic.dart';

class ArkhamParse {
  final Response response;
  final String link;

  ArkhamParse({
    required this.response,
    required this.link,
  });

  Future<Statistic> parseStatistic() async {
    final soup = BeautifulSoup(
      utf8.decode(response.bodyBytes),
    );

    //To check what soup back
    print(soup);

    final coin = soup.findAll('a', class_: 'TimeMachine_start__BDapq').toString();
    final previousValue = soup.findAll('span', class_: 'TimeMachine_numberWithIndicator__JnH6m').toString();

    return Statistic(
      coin: coin,
      previousValue: previousValue,
    );
  }
}