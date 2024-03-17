

enum StockIndicatorKeys {
  leftBracket(value: '('),
  rightBracket(value: ')'),
  semicolon(value: ';'),
  comma(value: ','),
  variable(value: ':'),
  variable2(value: ':='),
  ;

  final String value;

  const StockIndicatorKeys({required this.value});
}

