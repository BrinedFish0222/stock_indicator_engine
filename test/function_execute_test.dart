import 'package:flutter_test/flutter_test.dart';
import 'package:stock_indicator_engine/common/utils/reg_exp_utils.dart';
import 'package:stock_indicator_engine/function/function_execute.dart';
import 'package:stock_indicator_engine/model/candlestick_chart.dart';
import 'package:stock_indicator_engine/model/stock_indicator_engine_data.dart';

void main() {
  group('function_execute', () {
    test('matchFunctionContent', () {
      StockIndicatorEngineData data = StockIndicatorEngineData(
        chart: KChart(dataList: [
          CandlestickChartData(
              dateTime: DateTime.now(), open: 10, close: 12, high: 13, low: 9),
          CandlestickChartData(
              dateTime: DateTime.now(),
              open: 14,
              close: 11,
              high: 13.2,
              low: 8),
          CandlestickChartData(
              dateTime: DateTime.now(), open: 9, close: 10, high: 16, low: 9),
        ]),
        formula: '',
        parameters: [],
      );

      expect(
        RegExpUtils.matchFunctionContent(
            str: 'EMA(EMA(CLOSE,12.0),EMA(HIGH,CLOSE))'),
        'EMA(CLOSE,12.0),EMA(HIGH,CLOSE)',
      );

      expect(
        RegExpUtils.matchFunctionContent(str: 'EMA(CLOSE,12.0)'),
        'CLOSE,12.0',
      );

      expect(
        RegExpUtils.matchFunctionContent(
            str: 'EMA(MA(BD(12),12.0),EMA(HIGH,CLOSE))'),
        'MA(BD(12),12.0),EMA(HIGH,CLOSE)',
      );

      expect(
        FunctionExecute(function: 'TESTONE(1, 2)', data: data).run(),
        [3, 3, 3],
      );

      expect(
        FunctionExecute(function: 'TESTONE(CLOSE, 2)', data: data).run(),
        [14, 13, 12],
      );

      expect(
        FunctionExecute(function: 'TESTONE(CLOSE, CLOSE)', data: data).run(),
        [24, 22, 20],
      );

      expect(
        FunctionExecute(
          function: 'TESTONE(CLOSE, TESTONE(1, 2))',
          data: data,
        ).run(),
        [15, 14, 13],
      );
    });
    test('TESTONE', () {
      StockIndicatorEngineData data = StockIndicatorEngineData(
        chart: KChart(dataList: [
          CandlestickChartData(
              dateTime: DateTime.now(), open: 10, close: 12, high: 13, low: 9),
          CandlestickChartData(
              dateTime: DateTime.now(),
              open: 14,
              close: 11,
              high: 13.2,
              low: 8),
          CandlestickChartData(
              dateTime: DateTime.now(), open: 9, close: 10, high: 16, low: 9),
        ]),
        formula: '',
        parameters: [],
      );

      expect(
        FunctionExecute(
          function: 'TESTONE(CLOSE, TESTONE(CLOSE, 2))',
          data: data,
        ).run(),
        [26.0, 24.0, 22.0],
      );
    });
  });
}
