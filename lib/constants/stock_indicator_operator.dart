/// 运算符
enum StockIndicatorOperator {
  unknown(value: ''),
  add(value: '+'),
  sub(value: '-'),
  div(value: '/'),
  mul(value: '*'),
  ;

  final String value;

  const StockIndicatorOperator({required this.value});

  bool get isMul {
    return this == StockIndicatorOperator.mul;
  }

  bool get isDiv {
    return this == StockIndicatorOperator.div;
  }

  static bool isOperator(String value) {
    return StockIndicatorOperator.values
        .any((element) => element.value == value);
  }

  static StockIndicatorOperator? operator(String value) {
    return StockIndicatorOperator.values
        .firstWhere((element) => element.value == value, orElse: () => unknown);
  }
}
