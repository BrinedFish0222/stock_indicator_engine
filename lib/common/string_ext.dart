
extension StringExt on String {
  String replaceAllBySet(List<RegExp> fromList, String replace) {
    String result = this;
    for (var element in fromList) {
      result = result.replaceAll(element, replace);
    }

    return result;
  }

  bool get isBlank {
    return RegExp(r'^\s*$').hasMatch(this);
  }

  String get trimBlank {
    return trim().replaceAll(RegExp(r'\n'), '');
  }

  bool get isNumber {
    try {
      num.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}