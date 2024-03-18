import 'package:stock_indicator_engine/function/stock_indicator_function.dart';
import 'package:stock_indicator_engine/function/stock_indicator_function_type.dart';
import 'package:stock_indicator_engine/model/candlestick_chart.dart';

/// 测试函数1
class FunctionTest1 extends StockIndicatorFunction {

  @override
  String get code => 'TESTONE';

  @override
  List<double?> compute({
    required KChart chart,
    required List<List<double?>> params,
  }) {
    List<double?> param1 = params[0];
    List<double?> param2 = params[1];
    List<double?> result = [];

    for (int i = 0; i < param1.length; ++i) {
      double? data1 = param1[i];
      double? data2 = param2[i];
      if (data1 == null || data2 == null) {
        result.add(null);
        continue;
      }

      result.add(data1 + data2);
    }

    return result;
  }

  @override
  StockIndicatorFunctionType get type => StockIndicatorFunctionType.compute;
}
