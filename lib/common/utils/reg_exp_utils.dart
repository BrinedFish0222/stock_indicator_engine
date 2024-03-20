import 'package:stock_indicator_engine/constants/stock_indicator_constants.dart';

/// 正则工具
class RegExpUtils {
  static const String word = r'\b[a-zA-Z]+\b';

  static const String variables = r'\b[a-zA-Z]+(?=:|:=)\b';

  static Set<String> matchBatch({required String regExt, required String str}) {
    RegExp re = RegExp(regExt);
    Iterable<Match> matches = re.allMatches(str);
    Set<String> words = matches.map((match) => match.group(0)!).toSet();
    return words;
  }

  static String? match({required String regExt, required String str}) {
    RegExp re = RegExp(regExt);
    RegExpMatch? matches = re.firstMatch(str);
    return matches?[0];
  }

  /// 提取函数内部内容
  /// 例如：EMA(EMA(CLOSE,12.0),EMA(HIGH,CLOSE))
  /// 提取结果：EMA(CLOSE,12.0),EMA(HIGH,CLOSE)
  static String matchFunctionContent({required String str}) {
    int leftIndex = str.indexOf('(');
    if (leftIndex == -1) {
      return '';
    }

    return str.substring(leftIndex + 1, str.length - 1);
  }

  /// 切分函数参数
  static List<String> splitFunctionParam(String str) {
    if (str.isEmpty) {
      return [];
    }

    List<String> words = str.split('');
    List<String> stack = [];
    List<String> result = [];
    int leftBracket = 0;
    int rightBracket = 0;

    for (String word in words) {
      if (word == StockIndicatorKeys.comma.value &&
          leftBracket == rightBracket) {
        result.add(stack.join().trim());
        stack.length = 0;
        leftBracket = 0;
        rightBracket = 0;
        continue;
      } else if (word == StockIndicatorKeys.leftBracket.value) {
        leftBracket += 1;
      } else if (word == StockIndicatorKeys.rightBracket.value) {
        rightBracket += 1;
      }

      stack.add(word);
    }

    if (stack.isNotEmpty && stack.join().isNotEmpty) {
      result.add(stack.join().trim());
    }

    return result;
  }
}
