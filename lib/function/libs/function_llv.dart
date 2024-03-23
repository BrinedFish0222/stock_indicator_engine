import 'package:stock_indicator_engine/function/stock_indicator_function.dart';
import 'package:stock_indicator_engine/function/stock_indicator_function_type.dart';
import 'package:stock_indicator_engine/model/candlestick_chart.dart';

import '../function_utils.dart';

/// LLV函数
class FunctionLLV extends StockIndicatorFunction {
  @override
  String get code => 'LLV';

  @override
  List<double?> compute({
    required KChart chart,
    required List<List<double?>> params,
  }) {
    List<double?> xParam = params[0];
    List<double?> nParam = params[1];

    List<double?> result = [];

    for (int i = 0; i < xParam.length; ++i) {
      final double? val = xParam[i];
      final int n = nParam[i]?.toInt() ?? 0;
      if (n == 0) {
        result.add(null);
        continue;
      }

      if (i == 0) {
        result.add(val ?? 0);
        continue;
      }

      List<double?> data =
          FunctionUtils.reserve(data: xParam, currentIndex: i, n: n);

      double? min = FunctionUtils.min(data);
      result.add(min);
    }

    return result;
  }

  @override
  StockIndicatorFunctionType get type => StockIndicatorFunctionType.compute;
}
