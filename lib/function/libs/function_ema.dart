import 'package:stock_indicator_engine/function/stock_indicator_function_type.dart';

import 'package:stock_indicator_engine/model/candlestick_chart.dart';

import '../stock_indicator_function.dart';

/// EMA函数，参考地址：https://www.docin.com/p-1990587776.html
class FunctionEma extends StockIndicatorFunction {
  @override
  String get code => "EMA";

 /*  @override
  List<double?> compute(
      {required KChart chart, required List<List<double?>> params}) {
    List<double?> xParam = params[0];
    List<double?> nParam = params[1];

    List<double?> result = [];

    // 计算后续的EMA值
    for (int i = 0; i < xParam.length; ++i) {
      int n = nParam[i]!.toInt();

      // 获取当前位置的往前n位的x1,x2,x3...xn
      List<double?> xn = [];
      if (i < n) {
        xn = xParam.sublist(0, i + 1);
      } else {
        xn = xParam.sublist(i - n, i + 1);
      }

      double sum =
          xn.reduce((value, element) => (value ?? 0) + (element ?? 0)) ?? 0;

      if (sum == 0) {
        result.add(null);
        continue;
      }

      double xnCompute = 0;
      for (int j = 1; j <= xn.length; ++j) {
        xnCompute += j * (xn[j - 1] ?? 0);
      }

      result.add(xnCompute / sum);
    }

    return result;
  } */

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
