/// 变量定义错误
class VariablesDefineException implements Exception {
  VariablesDefineException();

  @override
  String toString() {
    return "在变量:前又错误的定义一次变量!";
  }
}
