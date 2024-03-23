/// 函数工具
class FunctionUtils {
  /// 保留数据
  /// [data] 数据
  /// [currentIndex] 当前索引位置
  /// [n] 保留数据的个数
  static List<double?> reserve({
    required List<double?> data,
    required int currentIndex,
    required int n,
  }) {
    if (data.isEmpty) {
      return [];
    }

    // 索引位置处于第一个
    if (currentIndex == 0) {
      return [data[0]];
    }

    // 索引位置小于n
    if (currentIndex < n) {
      return data.sublist(0, currentIndex + 1);
    }

    return data.sublist(currentIndex - (n - 1), currentIndex + 1);
  }

  static double roundDouble(double value, int places) {
    double factor = 10.0 * places;
    return (value * factor).round() / factor;
  }

  static double? min(List<double?> data) {
    if (data.isEmpty) {
      return null;
    }

    // 使用 where 方法过滤掉空值
    Iterable<double> filteredData =
        data.where((value) => value != null).cast<double>();

    // 使用 reduce 方法获取最小值
    double? minValue =
        filteredData.reduce((min, value) => min < value ? min : value);
    return minValue;
  }
}
