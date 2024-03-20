

/// 指标用户输入参数
class StockIndicatorInputParameter {
  final String name;
  final double value;

  StockIndicatorInputParameter({
    required this.name,
    this.value = 0,
  });

  StockIndicatorParameter toParameter(int length) {
    return StockIndicatorParameter(
        name: name, value: List.filled(length, value));
  }

  @override
  String toString() {
    return 'StockIndicatorParameter{name: $name, value: $value}';
  }
}

/// 指标参数
class StockIndicatorParameter {
  final String name;
  List<double?> value = [];

  StockIndicatorParameter({
    required this.name,
    required this.value,
  });

  StockIndicatorParameter.input({
    required this.name,
    required double? value,
    required int dataLength,
  }) {
    this.value = List.filled(dataLength, value);
  }
}

/// 测试公式结果
class TestFormulaResult {
  final bool success;
  final String message;

  const TestFormulaResult({
    required this.success,
    required this.message,
  });

  const TestFormulaResult.success({
    this.success = true,
    this.message = '测试通过',
  });

  const TestFormulaResult.fail({
    this.success = false,
    this.message = '公式错误',
  });

  @override
  String toString() {
    return 'TestFormulaResult{success: $success, message: $message}';
  }
}

/// 公式执行结果
class RunFormulaResult<T> {
  final bool success;
  final String message;
  final String messageDetails;
  final T data;

  const RunFormulaResult({
    required this.success,
    required this.message,
    this.messageDetails = '',
    required this.data,
  });

  const RunFormulaResult.success({
    this.success = true,
    this.message = '测试通过',
    this.messageDetails = '',
    required this.data,
  });

  const RunFormulaResult.fail({
    this.success = false,
    this.message = '公式错误',
    this.messageDetails = '',
    required this.data,
  });

  @override
  String toString() {
    return 'RunFormulaResult{success: $success, message: $message, data: $data}';
  }
}
