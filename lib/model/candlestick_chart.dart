
/// K线图数据
class KChart {

  KChart({required this.dataList});

  List<CandlestickChartData?> dataList;
}

/// 蜡烛图数据
class CandlestickChartData {
  DateTime dateTime;
  double open;
  double close;
  double high;
  double low;

  CandlestickChartData({
    required this.dateTime,
    required this.open,
    required this.close,
    required this.high,
    required this.low,
  });

  CandlestickChartData copyWith({
    DateTime? dateTime,
    double? open,
    double? close,
    double? high,
    double? low,
  }) {
    return CandlestickChartData(
      dateTime: dateTime ?? this.dateTime,
      open: open ?? this.open,
      close: close ?? this.close,
      high: high ?? this.high,
      low: low ?? this.low,
    );
  }
}
