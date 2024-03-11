
import 'package:stock_indicator_engine/stock_indicator.dart';
import 'package:stock_indicator_engine/utils/kline_util.dart';

import 'common/common_exception.dart';
import 'constants/stock_indicator_constants.dart';
import 'function/stock_indicator_function_library.dart';

/// 股票指标引擎
class StockIndicatorEngine {
  StockIndicatorEngine({
    required String formula,
    required List<StockIndicatorParameter> parameters,
  }) : _formula = formula {
    _parameters.addAll(parameters);

    _initFormula();
    _initVariables();
  }

  static const _className = 'StockIndicatorEngine';

  /// 公式
  String _formula;

  /// 参数
  ///   - 用户自定义输入的参数
  ///   - 公式中的变量
  final List<StockIndicatorParameter> _parameters = [];

  /// 测试公式
  TestFormulaResult test() {
    try {
      Set<String> unknownWords = _checkWords();
      if (unknownWords.isNotEmpty) {
        throw CommonException("未知字符：$unknownWords");
      }

      return const TestFormulaResult.success();
    } on Exception catch (e) {
      return TestFormulaResult.fail(message: (e).toString());
    }
  }

  /// 检查关键字正确性
  /// 如果存在未知关键字，返回未知关键字
  Set<String> _checkWords() {
    // 定义正则表达式，匹配单词
    RegExp wordRegExp = RegExp(r'\b[a-zA-Z]+\b');
    Iterable<Match> matches = wordRegExp.allMatches(_formula);
    Set<String> words = matches.map((match) => match.group(0)!).toSet();
    KlineUtil.logd('formula words: $words', name: _className);

    Set<String> unknownWords = {};
    for (String word in words) {
      bool has = false;
      if (!has) {
        has = _parameters.any((element) => element.name == word);
      }

      if (!has) {
        has = StockIndicatorFunctionLibrary().hasFunction(word);
      }

      if (!has) {
        unknownWords.add(word);
      }
    }

    return unknownWords;
  }

  /// 初始化公式
  /// 替换公式中的参数，返回新公式
  void _initFormula() {
    for (StockIndicatorParameter parameter in _parameters) {
      _formula = _formula.replaceAll(
          RegExp(r'\b' + parameter.name + r'\b'), parameter.value.toString());
    }

    // KlineUtil.logd('formula: \n$_formula', name: _className);
  }

  /// 初始化公式变量
  /// ```
  /// DIF:EMA(CLOSE,SHORT)-EMA(CLOSE,LONG)
  /// DEA:=EMA(DIF,MID);
  /// ```
  /// 上面的 DIF 和 DEA 就是变量
  void _initVariables() {
    RegExp variablesRegExp = RegExp(r'\b[a-zA-Z]+(?=:|:=)\b');
    Iterable<Match> matches = variablesRegExp.allMatches(_formula);
    List<StockIndicatorParameter> indicators = matches
        .map((match) => match.group(0)!)
        .map((e) => StockIndicatorParameter(
            name: e, value: 0, type: StockIndicatorParameterType.variable))
        .toList();
    _parameters.addAll(indicators);
    KlineUtil.logd('variables: $indicators', name: _className);
  }
}
