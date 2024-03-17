
/// 指标结构类型
enum StockIndicatorStructureType {
  /// 输出类型，例如：DIF:EMA(CLOSE,SHORT)-EMA(CLOSE,LONG);
  /// `DIF:`格式就是输出类型
  output,

  /// 不输出类型，例如：DIF:=EMA(CLOSE,SHORT)-EMA(CLOSE,LONG);
  /// `DIF:=`格式就是不输出类型
  mute,
}