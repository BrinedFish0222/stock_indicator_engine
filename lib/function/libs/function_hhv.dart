import 'package:stock_indicator_engine/function/stock_indicator_function.dart';
import 'package:stock_indicator_engine/function/stock_indicator_function_type.dart';
import 'package:stock_indicator_engine/model/candlestick_chart.dart';

import '../function_utils.dart';

/// HHV函数
class FunctionHHV extends StockIndicatorFunction {
  @override
  String get code => 'HHV';

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

      double? max = FunctionUtils.max(data);
      result.add(max);
    }

    return result;
  }

  @override
  StockIndicatorFunctionType get type => StockIndicatorFunctionType.compute;
}
