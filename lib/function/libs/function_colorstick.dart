import 'package:stock_indicator_engine/function/stock_indicator_function_type.dart';

import 'package:stock_indicator_engine/model/candlestick_chart.dart';

import '../stock_indicator_function.dart';

class FunctionColorstick extends StockIndicatorFunction {
  @override
  String get code => 'COLORSTICK';

  @override
  List<double?> compute({
    required CandlestickChart candlestickChart,
    required List<List<double?>> params,
  }) {
    return [];
  }

  @override
  int get paramCount => 0;

  @override
  StockIndicatorFunctionType get type => StockIndicatorFunctionType.fixed;
}
