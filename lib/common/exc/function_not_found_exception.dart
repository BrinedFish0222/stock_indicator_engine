
/// 异常：找不到函数
class FunctionNotFoundException {
  final dynamic name;

  FunctionNotFoundException([this.name]);

  @override
  String toString() {
    Object? message = name;
    if (message == null) return "FunctionNotFoundException";
    return "无法识别函数：$message";
  }
}