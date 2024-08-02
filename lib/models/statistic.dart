class Statistic {
  final List<Coin> coins;

  Statistic({
    required this.coins,
  });
}

class Coin {
  final String name;
  final String currentValue;
  final double cost;

  Coin({
    required this.name,
    required this.currentValue,
    required this.cost,
  });
}
