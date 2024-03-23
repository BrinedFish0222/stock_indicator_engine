import 'package:stock_indicator_engine/function/libs/function_high.dart';
import 'package:stock_indicator_engine/function/libs/function_low.dart';
import 'package:stock_indicator_engine/function/libs/function_ma.dart';
import 'package:stock_indicator_engine/function/libs/function_test1.dart';
import 'package:stock_indicator_engine/function/stock_indicator_function.dart';
import 'package:stock_indicator_engine/function/stock_indicator_function_type.dart';

import '../common/utils/kline_util.dart';
import 'libs/function_close.dart';
import 'libs/function_colorstick.dart';
import 'libs/function_ema.dart';

/// 股票指标函数库
class StockIndicatorFunctionLibrary {
  static final StockIndicatorFunctionLibrary _instance =
      StockIndicatorFunctionLibrary._internal();

  static const _className = 'StockIndicatorFunctionRegistry';

  StockIndicatorFunctionLibrary._internal() {
    register([
      FunctionTest1(),
      FunctionClose(),
      FunctionColorstick(),
      FunctionEma(),
      FunctionMa(),
      FunctionHigh(),
      FunctionLow(),
    ]);
  }

  factory StockIndicatorFunctionLibrary() {
    return _instance;
  }

  /// 存储股票指标函数的映射
  final List<StockIndicatorFunction> _functions = [];

  /// 注册股票指标函数
  void register(List<StockIndicatorFunction> newFunctions) {
    for (var newFunction in newFunctions) {
      _functions.removeWhere((element) => element.code == newFunction.code);
    }

    _functions.addAll(newFunctions);
  }

  bool hasFunction(String functionCode) {
    return getFunction(functionCode) != null;
  }

  /// 获取注册的股票指标函数
  StockIndicatorFunction? getFunction(String functionCode) {
    try {
      return _functions.firstWhere((element) => element.code == functionCode);
    } catch (e) {
      KlineUtil.loge('找不到函数: $functionCode', name: _className);
      return null;
    }
  }

  List<StockIndicatorFunction> get _fixedFunctions => _functions
      .where((e) => e.type == StockIndicatorFunctionType.fixed)
      .toList();

  Set<String> matchFixed(Set<String> words) {
    Set<String> result = {};

    for (var word in words) {
      bool flag = _fixedFunctions.any((element) => element.code == word);
      if (flag) {
        result.add(word);
      }
    }
    return result;
  }
}
