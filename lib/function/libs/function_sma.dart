import 'package:stock_indicator_engine/function/stock_indicator_function_type.dart';

import 'package:stock_indicator_engine/model/candlestick_chart.dart';

import '../stock_indicator_function.dart';

/// SMA函数
/// 参考链接：https://www.bilibili.com/video/BV1MV411175y/?spm_id_from=333.337.search-card.all.click&vd_source=e8dbc6718d1cd9b057596d21f3e84800
class FunctionSMA extends StockIndicatorFunction {
  @override
  String get code => "SMA";

  @override
  List<double?> compute(
      {required KChart chart, required List<List<double?>> params}) {
    List<double?> xParam = params[0];
    List<double?> nParam = params[1];
    List<double?> mParam = params[2];

    List<double?> result = [];

    for (int i = 0; i < xParam.length; ++i) {
      double? val = xParam[i];
      if (i == 0) {
        result.add(val ?? 0);
        continue;
      }

      double n = nParam[i] ?? 0;
      double m = mParam[i] ?? 0;
      val ??= 0;

      if (n == 0) {
        result.add(null);
        continue;
      }

      // 当前值赋予权重
      double weightVal = val * (m / n);
      // 上一个权重值赋予新权重
      double preWeightVal = (result[i - 1] ?? 0) * ((n - m) / n);
      result.add(weightVal + preWeightVal);
    }

    return result;
  }

  @override
  StockIndicatorFunctionType get type => StockIndicatorFunctionType.compute;
}
