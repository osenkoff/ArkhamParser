class Statistic {
  final List<Coin> coins;

  Statistic({
    required this.coins,
  });
}

class Coin {
  final String name;
  final double previousValue;
  final double currentValue;
  final double cost;

  Coin({
    required this.name,
    required this.previousValue,
    required this.currentValue,
    required this.cost,
  });
}
