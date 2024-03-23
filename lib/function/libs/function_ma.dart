import 'package:stock_indicator_engine/common/utils/kline_util.dart';
import 'package:stock_indicator_engine/function/function_utils.dart';
import 'package:stock_indicator_engine/model/candlestick_chart.dart';

import 'package:stock_indicator_engine/function/stock_indicator_function_type.dart';

import '../stock_indicator_function.dart';

/// MA，参考地址：https://www.docin.com/p-1990587776.html
class FunctionMa extends StockIndicatorFunction {
  @override
  String get code => 'MA';

  @override
  List<double?> compute(
      {required KChart chart, required List<List<double?>> params}) {
    List<double?> xParam = params[0];
    List<double?> nParam = params[1];

    List<double?> result = [];

    // 计算后续的EMA值
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

      double dataSum = KlineUtil.sum(data);
      result.add(dataSum / data.length);
    }

    return result;
  }

  @override
  StockIndicatorFunctionType get type => StockIndicatorFunctionType.compute;
}
