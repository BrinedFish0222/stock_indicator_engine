import 'package:stock_indicator_engine/function/stock_indicator_function_type.dart';

import '../model/candlestick_chart.dart';

/// 指标函数规范
abstract class StockIndicatorFunction {

  /// 编号，例如：CLOSE、EMA、HIGH 等
  String get code;

  /// 函数类型
  StockIndicatorFunctionType get type;

  /// 计算
  /// [candlestickChart] K线图数据
  /// [params] 参数列表
  List<double?> compute({
    required KChart candlestickChart,
    required List<List<double?>> params,
  });
}
