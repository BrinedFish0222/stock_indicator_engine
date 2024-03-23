import 'package:flutter_test/flutter_test.dart';
import 'package:stock_indicator_engine/model/stock_indicator_structure.dart';
import 'package:stock_indicator_engine/stock_indicator.dart';
import 'package:stock_indicator_engine/stock_indicator_engine.dart';

import 'example_data/k_data.dart';

void main() {
  test('MACD', () {
    List<StockIndicatorInputParameter> parameters = [
      StockIndicatorInputParameter(name: 'SHORT', value: 12),
      StockIndicatorInputParameter(name: 'LONG', value: 26),
      StockIndicatorInputParameter(name: 'MID', value: 9),
    ];

    String formula = """
      DIF:EMA(CLOSE,SHORT)-EMA(CLOSE,LONG);
      DEA:EMA(DIF,MID);
      MACD:(DIF-DEA)*2,COLORSTICK;
  """;

    RunFormulaResult<List<StockIndicatorStructure>> result =
        StockIndicatorEngine(
      chart: payhChart,
      formula: formula,
      inputParameters: parameters,
    ).run();

    expect(result.success, true);
    expect(result.data?[0].data.last?.toStringAsFixed(3), '0.129');
    expect(result.data?[1].data.last?.toStringAsFixed(2), '0.17');
    expect(result.data?[2].data.last?.toStringAsFixed(2), '-0.08');
  });
}
