import 'package:stock_indicator_engine/common/compute_utils.dart';
import 'package:stock_indicator_engine/common/string_ext.dart';
import 'package:stock_indicator_engine/function/function_execute.dart';

import '../constants/stock_indicator_constants.dart';
import '../constants/stock_indicator_operator.dart';
import '../model/stock_indicator_engine_data.dart';
import '../model/stock_indicator_structure.dart';

/// 函数解析器
class FunctionParser {
  FunctionParser({
    required this.structure,
    required this.data,
  }) {
    _init(structure.formula);
  }

  /// 指标结构
  final StockIndicatorStructure structure;

  /// 指标数据
  final StockIndicatorEngineData data;

  /// 解析的函数
  final List<String> _functions = [];

  /// 运算符
  final List<String> _operators = [];

  /// 执行
  List<double?> run() {
    List<List<double?>> executeResults = [];
    for (String function in _functions) {
      List<double?> result = FunctionExecute(
        function: function,
        data: data,
      ).run();
      executeResults.add(result);
    }

    int length = executeResults.first.length;
    List<double?> result = [];
    final List<double?> currentComputeDataList = [];
    // 统计结果
    for (int i = 0; i < length; ++i) {
      for (var es in executeResults) {
        currentComputeDataList.add(es[i]);
      }

      double? value = ComputeUtils.compute(
        dataList: currentComputeDataList,
        operators: _operators,
      );
      result.add(value);

      currentComputeDataList.clear();
    }

    return result;
  }

  /// 提取公式中的函数
  void _init(String formula) {
    formula = formula.replaceAll(' ', '');
    List<String> words = formula.split('');
    words = _removeOuterBrackets(words);
    List<String> stack = [];

    int length = words.length;
    int leftBracketNumber = 0;
    int rightBracketNumber = 0;

    for (int i = 0; i < length; ++i) {
      String word = words[i];
      if (word == StockIndicatorKeys.leftBracket.value) {
        leftBracketNumber += 1;
      } else if (word == StockIndicatorKeys.rightBracket.value) {
        rightBracketNumber += 1;
      }

      StockIndicatorOperator? indicatorOperator =
          StockIndicatorOperator.operator(word);
      if (indicatorOperator != StockIndicatorOperator.unknown) {
        _operators.add(indicatorOperator.value);
      }

      if (indicatorOperator != StockIndicatorOperator.unknown &&
          leftBracketNumber == rightBracketNumber) {
        // 到关键运算符位置
        if (!stack.join().isNumber) {
          _functions.add(stack.join());
        }

        stack.length = 0;
        continue;
      }

      stack.add(word);
    }

    if (stack.isNotEmpty && stack.join().isNotEmpty) {
      _functions.add(stack.join());
    }
  }

  /// 删除最外层括号
  List<String> _removeOuterBrackets(List<String> formulaWords) {
    if (formulaWords.isEmpty) {
      return formulaWords;
    }

    if (!(formulaWords[0] == StockIndicatorKeys.leftBracket.value &&
        formulaWords[formulaWords.length - 1] ==
            StockIndicatorKeys.rightBracket.value)) {
      return formulaWords;
    }

    List<String> leftBracketStack = [];

    int length = formulaWords.length;
    bool flag = false;
    for (int i = 0; i < length; ++i) {
      String word = formulaWords[i];

      if (word == StockIndicatorKeys.leftBracket.value) {
        leftBracketStack.add(word);
      }

      if (word == StockIndicatorKeys.rightBracket.value) {
        leftBracketStack.length = leftBracketStack.length - 1;
        if (leftBracketStack.isEmpty && i == length - 1) {
          flag = true;
        } else if (leftBracketStack.isEmpty) {
          break;
        }
      }
    }

    if (flag) {
      formulaWords.removeAt(0);
      formulaWords.removeAt(formulaWords.length - 1);
    }

    return formulaWords;
  }
}
