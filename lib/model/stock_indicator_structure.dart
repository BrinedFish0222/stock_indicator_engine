
import 'package:stock_indicator_engine/constants/stock_indicator_structure_type.dart';

/// 指标结构
/// 例如：
///   - {name: DIF, formula: EMA(CLOSE,SHORT)-EMA(CLOSE,LONG), fixedFunctions: {}}
///   - {name: DEA, formula: EMA(DIF,MID), fixedFunctions: {}}
///   - {name: MACD, formula: (DIF-DEA)*2, fixedFunctions: {COLORSTICK}}
class StockIndicatorStructure {
  final String name;

  final StockIndicatorStructureType type;

  /// 公式
  final String formula;

  /// 例如：COLORSTICK等，无需解析的函数
  final Set<String> fixedFunctions;

  List<double?> data = [];

  StockIndicatorStructure({
    this.name = '',
    this.type = StockIndicatorStructureType.output,
    required this.formula,
    required this.fixedFunctions,
  });

  @override
  String toString() {
    return 'StockIndicatorStructure{name: $name, type: $type, formula: $formula, fixedFunctions: $fixedFunctions, data: $data}';
  }
}