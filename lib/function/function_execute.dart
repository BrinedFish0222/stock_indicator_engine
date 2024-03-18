import 'package:stock_indicator_engine/utils/reg_exp_utils.dart';
import 'package:stock_indicator_engine/utils/string_ext.dart';
import 'package:stock_indicator_engine/function/stock_indicator_function.dart';
import 'package:stock_indicator_engine/function/stock_indicator_function_library.dart';
import 'package:stock_indicator_engine/utils/kline_util.dart';

import '../model/stock_indicator_engine_data.dart';
import '../stock_indicator.dart';

/// 函数执行器
/// 解析有参数的函数块，例如：EMA(EMA(CLOSE,12.0),12.0)
/// 该函数负责解析：EMA(CLOSE,12.0)、EMA(EMA(CLOSE,12.0),12.0);
/// [noParamData] 无参函数数据
class FunctionExecute {
  final String function;

  final StockIndicatorEngineData data;

  /// 当前函数
  late StockIndicatorFunction _currentFunction;

  /// 子函数
  final List<FunctionExecute> _subFunctions = [];

  FunctionExecute({
    required this.function,
    required this.data,
    // required this.paramData,
  }) {
    _initCurrentFunction();
    _initSubFunction();
  }

  /// 执行函数，获取结果
  List<double?> run() {
    // 处理数字情况
    if (function.isNumber) {
      double value = double.parse(function);
      return List<double?>.filled(data.chart.dataList.length, value);
    }

    // 如果能在参数中找到，直接返回
    StockIndicatorParameter? param = KlineUtil.firstWhere(data.parameters, (element) => element.name == function);
    if (param != null) {
      return param.value;
    }

    // 如果没有子函数，表示属于无参函数，看缓存参数中是否拥有
    /*if (_subFunctions.isEmpty && paramData[function] != null) {
      return paramData[function] ??
          List<double?>.filled(data.candlestickChart.dataList.length, null);
    }*/

    // 得出子函数结果
    List<List<double?>> subFunctionResult = [];
    for (FunctionExecute subFunction in _subFunctions) {
      subFunctionResult.add(subFunction.run());
    }

    // 根据子函数结果计算当前函数结果
    var result = _currentFunction.compute(
      chart: data.chart,
      params: subFunctionResult,
    );

    return result;
  }

  /// 初始化当前函数
  void _initCurrentFunction() {
    String? functionName = RegExpUtils.match(
      regExt: RegExpUtils.word,
      str: function,
    );

    // 纯数字情况
    if (function.isNumber) {
      return;
    }

    if (functionName == null) {
      throw Exception('无法解析函数');
    }

    if (data.parameters.any((element) => element.name == functionName)) {
      return;
    }

    StockIndicatorFunction? stockIndicatorFunction =
        StockIndicatorFunctionLibrary().getFunction(functionName);
    if (stockIndicatorFunction == null) {
      throw Exception('无法识别函数：$functionName');
    }

    _currentFunction = stockIndicatorFunction;
  }

  /// 初始化子函数
  /// 例如：EMA(EMA(CLOSE,12.0),EMA(HIGH,CLOSE))
  /// 初始化得出子函数：EMA(CLOSE,12.0)、EMA(HIGH,CLOSE)
  void _initSubFunction() {
    // 去掉外层函数
    String content = RegExpUtils.matchFunctionContent(str: function);
    List<String> params = RegExpUtils.splitFunctionParam(content);
    for (String param in params) {
      if (param.isEmpty) {
        continue;
      }
      _subFunctions.add(FunctionExecute(
        function: param.trim(),
        data: data,
        // paramData: paramData,
      ));
    }
  }
}
