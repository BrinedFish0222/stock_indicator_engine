import 'package:stock_indicator_engine/function/stock_indicator_function.dart';
import 'package:stock_indicator_engine/function/stock_indicator_function_type.dart';
import 'package:stock_indicator_engine/model/candlestick_chart.dart';

class FunctionClose extends StockIndicatorFunction {

  @override
  String get code => 'CLOSE';

  @override
  List<double?> compute({
    required KChart chart,
    required List<List<double?>> params,
  }) {
    if (chart.dataList.isEmpty) {
      return [];
    }

    return chart.dataList.map((e) => e?.close).toList();
  }

  @override
  StockIndicatorFunctionType get type => StockIndicatorFunctionType.compute;
}
