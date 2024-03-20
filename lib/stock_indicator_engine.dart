import 'package:stock_indicator_engine/common/utils/reg_exp_utils.dart';
import 'package:stock_indicator_engine/common/utils/string_ext.dart';
import 'package:stock_indicator_engine/model/candlestick_chart.dart';
import 'package:stock_indicator_engine/stock_indicator.dart';

import 'common/exc/common_exception.dart';
import 'common/exc/variables_define_exception.dart';
import 'common/utils/kline_util.dart';
import 'constants/stock_indicator_constants.dart';
import 'constants/stock_indicator_structure_type.dart';
import 'function/function_parser.dart';
import 'function/stock_indicator_function_library.dart';
import 'model/stock_indicator_engine_data.dart';
import 'model/stock_indicator_structure.dart';

/// 股票指标引擎
class StockIndicatorEngine {
  StockIndicatorEngine({
    required KChart chart,
    required String formula,
    required this.inputParameters,
  }) {
    _data = StockIndicatorEngineData.input(
      chart: chart,
      formula: formula,
      inputParameters: inputParameters,
    );

    _initFormula();
    _initVariables();
    _initFunctionStructure();
  }

  static const _className = 'StockIndicatorEngine';

  /// 用户输入的参数
  List<StockIndicatorInputParameter> inputParameters;

  late StockIndicatorEngineData _data;

  /// 执行公式
  RunFormulaResult run() {
    for (StockIndicatorStructure structure in _data.functionStructure) {
      List<double?> dataList = FunctionParser(
        structure: structure,
        data: _data,
      ).run();
      structure.data = dataList;

      _data.updateParameter(name: structure.name, dataList: dataList);
    }

    return RunFormulaResult.success(data: _data.functionStructure);
  }

  /// 测试公式
  RunFormulaResult test() {
    try {
      // 检测未知关键字
      Set<String> unknownWords = _checkUnknownWords();
      if (unknownWords.isNotEmpty) {
        throw CommonException("未知字符：$unknownWords");
      }

      for (StockIndicatorStructure fs in _data.functionStructure) {
        // 检测一条公式变量不唯一问题
        RunFormulaResult testVariablesResult = _testVariables(fs);
        if (testVariablesResult.fail) {
          return testVariablesResult;
        }
      }

      return const RunFormulaResult.success(data: null);
    } catch (e) {
      return RunFormulaResult.fail(data: null, message: e.toString());
    }
  }

  /// 检测变量是否正常
  RunFormulaResult _testVariables(StockIndicatorStructure structure) {
    try {
      String formula = structure.originFormula;
      RegExp regExp = RegExp(r'(:)+');
      Iterable<Match> matches = regExp.allMatches(formula);

      if (matches.length > 1) {
        throw VariablesDefineException();
      }

      regExp = RegExp(r'(::)+');
      matches = regExp.allMatches(formula);
      if (matches.isNotEmpty) {
        throw VariablesDefineException();
      }

      return const RunFormulaResult.success();
    } catch (e) {
      return RunFormulaResult.fail(
          message: e.toString(), messageDetails: structure.originFormula);
    }
  }

  /// 检查未知关键字
  /// 如果存在未知关键字，返回未知关键字
  Set<String> _checkUnknownWords() {
    // 定义正则表达式，匹配单词
    RegExp wordRegExp = RegExp(r'\b[a-zA-Z]+\b');
    Iterable<Match> matches = wordRegExp.allMatches(_data.formula);
    Set<String> words = matches.map((match) => match.group(0)!).toSet();
    KlineUtil.logd('formula words: $words', name: _className);

    Set<String> unknownWords = {};
    for (String word in words) {
      bool has = false;
      if (!has) {
        // 参数条件
        has = _data.parameters.any((element) => element.name == word);
      }

      if (!has) {
        // 函数
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
    for (StockIndicatorInputParameter parameter in inputParameters) {
      _data.formula = _data.formula.replaceAll(
          RegExp(r'\b' + parameter.name + r'\b'), parameter.value.toString());
    }

    KlineUtil.logd('replace parameter after formula: \n${_data.formula}',
        name: _className);
  }

  /// 初始化公式变量
  /// ```
  /// DIF:EMA(CLOSE,SHORT)-EMA(CLOSE,LONG)
  /// DEA:=EMA(DIF,MID);
  /// ```
  /// 上面的 DIF 和 DEA 就是变量
  void _initVariables() {
    RegExp variablesRegExp = RegExp(RegExpUtils.variables);
    Iterable<Match> matches = variablesRegExp.allMatches(_data.formula);
    List<StockIndicatorParameter> indicators = matches
        .map((match) => match.group(0)!)
        .map((e) => StockIndicatorParameter.input(
              name: e,
              value: 0,
              dataLength: _data.chart.dataList.length,
            ))
        .toList();

    _data.parameters.addAll(indicators);
  }

  /// 初始化公式结构
  void _initFunctionStructure() {
    if (_data.formula.isEmpty) {
      return;
    }

    List<String> formulas =
        _data.formula.split(StockIndicatorKeys.semicolon.value);
    for (String formula in formulas) {
      String originFormula = formula;

      if (formula.isBlank) {
        continue;
      }

      // 识别变量类型
      StockIndicatorStructureType type = StockIndicatorStructureType.output;
      if (formula.contains(StockIndicatorKeys.variable2.value)) {
        // 变量是非输出类型
        type = StockIndicatorStructureType.mute;
      }

      // 识别固定函数，从公式中删除
      Set<String> words =
          RegExpUtils.matchBatch(regExt: RegExpUtils.word, str: formula);
      Set<String> fixedWords =
          StockIndicatorFunctionLibrary().matchFixed(words);
      var fixedWordMatchList =
          fixedWords.map((e) => RegExp('\\b$e\\b')).toList();
      formula = formula.replaceAllBySet(fixedWordMatchList, '');

      // 识别公式中的开头变量，然后从公式中删除
      String variableWord = RegExpUtils.match(
            regExt: RegExpUtils.variables,
            str: formula,
          ) ??
          '';
      formula = formula.replaceFirst(
          RegExp(
              '$variableWord${StockIndicatorKeys.variable.value}|$variableWord${StockIndicatorKeys.variable2.value}'),
          '');

      // 去空格、去多余的逗号
      formula = formula.trimBlank;
      while (formula.endsWith(StockIndicatorKeys.comma.value)) {
        formula = formula.substring(0, formula.length - 1);
      }

      var structure = StockIndicatorStructure(
        name: variableWord,
        type: type,
        originFormula: originFormula,
        formula: formula,
        fixedFunctions: fixedWords,
      );

      KlineUtil.logd('function structure: $structure');
      _data.functionStructure.add(structure);
    }
  }
}
