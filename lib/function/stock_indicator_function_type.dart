
/// 指标函数类型
enum StockIndicatorFunctionType {
  /// 计算型，例如：EMA、CLOSE等需要进行运算的函数
  compute,

  /// 固定型，例如：COLORSTICK
  fixed,
}