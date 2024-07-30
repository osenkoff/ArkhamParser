class Statistic {
  final String coin;
  final String previousValue;
  //final String? currentValue;

  Statistic({
    required this.coin,
    required this.previousValue,
    //this.currentValue,
  });

  @override
  String toString() {
    return coin;
  }
}