import 'package:flutter_test/flutter_test.dart';
import 'package:stock_indicator_engine/stock_indicator_engine.dart';

import 'example_data/k_data.dart';

void main() {
  test('HIGH', () {
    String formula = """
      ABC:HIGH;
  """;

    var result = StockIndicatorEngine(
      chart: payhChart,
      formula: formula,
      inputParameters: [],
    ).run();

    expect(result.success, true);
    expect(result.data?[0].data.last?.toStringAsFixed(2), '10.45');
  });

  test('LOW', () {
    String formula = """
      ABC:LOW;
  """;

    var result = StockIndicatorEngine(
      chart: payhChart,
      formula: formula,
      inputParameters: [],
    ).run();

    expect(result.success, true);
    expect(result.data?[0].data.last?.toStringAsFixed(2), '10.31');
  });

  test('LLV', () {
    String formula = """
      ABC:LLV(LOW,7);
  """;

    var result = StockIndicatorEngine(
      chart: payhChart,
      formula: formula,
      inputParameters: [],
    ).run();

    expect(result.success, true);
    expect(result.data?[0].data.last?.toStringAsFixed(2), '10.20');
  });
}
