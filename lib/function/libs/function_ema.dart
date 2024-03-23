import 'package:stock_indicator_engine/function/stock_indicator_function_type.dart';

import 'package:stock_indicator_engine/model/candlestick_chart.dart';

import '../stock_indicator_function.dart';

/// EMA函数
class FunctionEma extends StockIndicatorFunction {
  @override
  String get code => "EMA";

  @override
  List<double?> compute(
      {required KChart chart, required List<List<double?>> params}) {
    List<double?> xParam = params[0];
    List<double?> nParam = params[1];

    List<double?> result = [];

    // 计算后续的EMA值
    for (int i = 0; i < xParam.length; ++i) {
      double? val = xParam[i];
      if (i == 0) {
        result.add(val ?? 0);
        continue;
      }

      double n = nParam[i] ?? 0;
      val ??= 0;

      double weightVal = val * (2 / (n + 1));
      double preWeightVal = (result[i - 1] ?? 0) * ((n - 1) / (n + 1));
      result.add(weightVal + preWeightVal);
    }

    return result;
  }

  @override
  StockIndicatorFunctionType get type => StockIndicatorFunctionType.compute;
}
