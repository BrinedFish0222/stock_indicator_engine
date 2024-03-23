import 'package:flutter_test/flutter_test.dart';
import 'package:stock_indicator_engine/constants/stock_indicator_structure_type.dart';
import 'package:stock_indicator_engine/model/candlestick_chart.dart';
import 'package:stock_indicator_engine/stock_indicator.dart';
import 'package:stock_indicator_engine/stock_indicator_engine.dart';


void main() {
  KChart chart = KChart(dataList: [
    CandlestickChartData(
        dateTime: DateTime.now(), open: 10, close: 12, high: 13, low: 9),
    CandlestickChartData(
        dateTime: DateTime.now(), open: 14, close: 11, high: 13.2, low: 8),
    CandlestickChartData(
        dateTime: DateTime.now(), open: 9, close: 10, high: 16, low: 9),
  ]);

  List<StockIndicatorInputParameter> parameters = [
    StockIndicatorInputParameter(name: 'SHORT', value: 12),
    StockIndicatorInputParameter(name: 'LONG', value: 26),
    StockIndicatorInputParameter(name: 'MID', value: 9),
  ];

  test('simple', () {
    String formula = """
      DIF:CLOSE-TESTONE(1,2)-1;
      DEA:TESTONE(CLOSE,2);
      MACD:TESTONE(CLOSE,TESTONE(CLOSE,2));
  """;

    var result = StockIndicatorEngine(
      chart: chart,
      formula: formula,
      inputParameters: [],
    ).run();
    expect(result.data?[0].data, [8.0, 7.0, 6.0]);
    expect(result.data?[1].data, [14.0, 13.0, 12.0]);
    expect(result.data?[2].data, [26.0, 24.0, 22.0]);
  });

  test('simple2', () {
    String formula = """
      DIF:CLOSE-TESTONE(1,2)-1;
      DEA:TESTONE(DIF,2);
      MACD:TESTONE(TESTONE(DEA,2),DIF);
  """;

    var result = StockIndicatorEngine(
      chart: chart,
      formula: formula,
      inputParameters: [],
    ).run();

    expect(result.data?[0].data, [8.0, 7.0, 6.0]);
    expect(result.data?[1].data, [10.0, 9.0, 8.0]);
    expect(result.data?[2].data, [20.0, 18.0, 16.0]);
  });

  test('simple3', () {
    String formula = """
      DIF:CLOSE-TESTONE(1,2)-1;
      DEA:TESTONE(DIF,2),COLORSTICK;
      MACD:=TESTONE(TESTONE(DEA,2),DIF);
  """;

    var result = StockIndicatorEngine(
      chart: chart,
      formula: formula,
      inputParameters: [],
    ).run();

    expect(result.data?[0].name, 'DIF');
    expect(result.data?[0].data, [8.0, 7.0, 6.0]);

    expect(result.data?[1].name, 'DEA');
    expect(result.data?[1].data, [10.0, 9.0, 8.0]);
    expect(result.data?[1].fixedFunctions, {'COLORSTICK'});

    expect(result.data?[2].type, StockIndicatorStructureType.mute);
  });

  test('simple4', () {
    String formula = """
      DIF:CLOSE-TESTONE(SHORT,2)-1;
      DEA:TESTONE(DIF,LONG),COLORSTICK;
      MACD:=TESTONE(TESTONE(DEA,MID),DIF);
  """;

    RunFormulaResult result = StockIndicatorEngine(
      chart: chart,
      formula: formula,
      inputParameters: parameters,
    ).run();

    expect(result.data[0].name, 'DIF');
    expect(result.data[0].data, [-3.0, -4.0, -5.0]);

    expect(result.data[1].name, 'DEA');
    expect(result.data[1].data, [23.0, 22.0, 21.0]);
    expect(result.data[1].fixedFunctions, {'COLORSTICK'});

    expect(result.data[2].name, 'MACD');
    expect(result.data[2].type, StockIndicatorStructureType.mute);
    expect(result.data[2].data, [29.0, 27.0, 25.0]);
  });

  test('simple5', () {
    String formula = """

      DIF::CLOSE-TESTONE(SHORT,2) - 1,;

      DEA:TESTONE(DIF,LONG), COLORSTICK;

      MACD:=TESTONE(  TESTONE(DEA,MID) , DIF);
  """;

    RunFormulaResult result = StockIndicatorEngine(
      chart: chart,
      formula: formula,
      inputParameters: parameters,
    ).test();

    // print('错误信息：${result.message}');
    // print('错误句子：${result.messageDetails}');
    expect(result.success, false);
  });
}
