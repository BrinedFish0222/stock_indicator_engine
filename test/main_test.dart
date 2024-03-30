import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_indicator_engine/model/stock_indicator_structure.dart';
import 'package:stock_indicator_engine/stock_indicator.dart';
import 'package:stock_indicator_engine/stock_indicator_engine.dart';

import 'example_data/k_data.dart';

void main() {
  test('MA', ma);
  test('MACD', macd);
  test('KDJ', kdj);
}

void kdj() {
  List<StockIndicatorInputParameter> parameters = [
    StockIndicatorInputParameter(name: 'N', value: 9),
    StockIndicatorInputParameter(name: 'M1', value: 3),
    StockIndicatorInputParameter(name: 'M2', value: 3),
  ];

  String formula = """
      RSV:=(CLOSE-LLV(LOW,N))/(HHV(HIGH,N)-LLV(LOW,N))*100;
      K:SMA(RSV,M1,1);
      D:SMA(K,M2,1);
      J:3*K-2*D;
  """;

  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  RunFormulaResult<List<StockIndicatorStructure>> result = StockIndicatorEngine(
    chart: payhChart,
    formula: formula,
    inputParameters: parameters,
  ).run();
  stopwatch.stop();
  if (kDebugMode) {
    print('KDJ execution time: ${stopwatch.elapsedMilliseconds} milliseconds');
  }

  expect(result.success, true);
  expect(result.data?[1].data.last?.toStringAsFixed(2), '40.65');
  expect(result.data?[2].data.last?.toStringAsFixed(2), '43.23');
  expect(result.data?[3].data.last?.toStringAsFixed(2), '35.50');
}

void macd() {
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

  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  RunFormulaResult<List<StockIndicatorStructure>> result = StockIndicatorEngine(
    chart: payhChart,
    formula: formula,
    inputParameters: parameters,
  ).run();
  stopwatch.stop();
  if (kDebugMode) {
    print("MACD execution time: ${stopwatch.elapsedMilliseconds} milliseconds");
  }

  expect(result.success, true);
  expect(result.data?[0].data.last?.toStringAsFixed(3), '0.129');
  expect(result.data?[1].data.last?.toStringAsFixed(2), '0.17');
  expect(result.data?[2].data.last?.toStringAsFixed(2), '-0.08');
}

void ma() {
  List<StockIndicatorInputParameter> parameters = [
    StockIndicatorInputParameter(name: 'M1', value: 5),
    StockIndicatorInputParameter(name: 'M2', value: 10),
    StockIndicatorInputParameter(name: 'M3', value: 20),
    StockIndicatorInputParameter(name: 'M4', value: 60),
    StockIndicatorInputParameter(name: 'M5', value: 0),
    StockIndicatorInputParameter(name: 'M6', value: 0),
    StockIndicatorInputParameter(name: 'M7', value: 0),
    StockIndicatorInputParameter(name: 'M8', value: 0),
  ];

  String formula = """
      MA1:MA(CLOSE,M1);
      MA2:MA(CLOSE,M2);
      MA3:MA(CLOSE,M3);
      MA4:MA(CLOSE,M4);
      MA5:MA(CLOSE,M5);
      MA6:MA(CLOSE,M6);
      MA7:MA(CLOSE,M7);
      MA8:MA(CLOSE,M8);
  """;

  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  RunFormulaResult<List<StockIndicatorStructure>> result = StockIndicatorEngine(
    chart: payhChart,
    formula: formula,
    inputParameters: parameters,
  ).run();
  stopwatch.stop();
  if (kDebugMode) {
    print('MA execution time: ${stopwatch.elapsedMilliseconds} milliseconds');
  }

  expect(result.success, true);
  expect(result.data?[0].data.last?.toStringAsFixed(2), '10.44');
  expect(result.data?[1].data.last?.toStringAsFixed(2), '10.44');
  expect(result.data?[2].data.last?.toStringAsFixed(2), '10.44');
}
