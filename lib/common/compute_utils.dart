import 'package:math_expressions/math_expressions.dart';

class ComputeUtils {
  static double compute({
    required List<double?> dataList,
    required List<String> operators,
  }) {
    List<double> values = dataList.map((e) => e ?? 0).toList();
    String computeStr = '';
    int length = values.length;
    for (int i = 0; i < length; ++i) {
      computeStr += values[i].toString();

      if (i == length - 1) {
        break;
      }
      computeStr += operators[i];
    }

    Parser p = Parser();
    Expression exp = p.parse(computeStr);
    ContextModel cm = ContextModel();
    return exp.evaluate(EvaluationType.REAL, cm);
  }
}
