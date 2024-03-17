
import 'package:stock_indicator_engine/model/stock_indicator_structure.dart';

import '../stock_indicator.dart';
import '../utils/kline_util.dart';
import 'candlestick_chart.dart';

/// 股票指标引擎数据
class StockIndicatorEngineData {
  /// K线数据
  final CandlestickChart candlestickChart;

  /// 公式
  String formula;

  /// 参数，例如：CLOSE => [1,2,3...]
  late final List<StockIndicatorParameter> parameters;

  /// 公式结构
  final List<StockIndicatorStructure> functionStructure = [];

  StockIndicatorEngineData({
    required this.candlestickChart,
    required this.formula,
    required this.parameters,
  });

  StockIndicatorEngineData.input({
    required this.candlestickChart,
    required this.formula,
    required List<StockIndicatorInputParameter> inputParameters,
  }) {
    parameters = inputParameters
        .map((e) => e.toParameter(candlestickChart.dataList.length))
        .toList();
  }

  /// 更新参数
  void updateParameter({
    required String name,
    required List<double?> dataList,
  }) {
    StockIndicatorParameter? parameter = KlineUtil.firstWhere(
        parameters, (element) => element.name == name);
    if (parameter == null) {
      // 新增
      parameters.add(StockIndicatorParameter(name: name, value: dataList));
    } else {
      parameter.value = dataList;
    }
  }
}

