import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:stock_indicator_engine/constants/stock_indicator_constants.dart';

class KlineUtil {
  static void logd(String text, {String name = ''}) {
    if (kReleaseMode) {
      return;
    }
    developer.log(text, name: name);
  }

  static void loge(String text, {String name = ''}) {
    /*if (kReleaseMode) {
      return;
    }*/
    developer.log(text, name: name);
  }

  static E? firstWhere<E>(List<E>? list, bool Function(E element) test,
      {E Function()? orElse}) {
    if (list == null || list.isEmpty) {
      return null;
    }

    for (E element in list) {
      if (test(element)) return element;
    }
    if (orElse != null) return orElse();

    return null;
  }

  /// 是否是块，例如：(DIF-DEA)
  static bool isChunks(String function) {
    if (function.isEmpty) {
      return false;
    }

    if (!(function.startsWith(StockIndicatorKeys.leftBracket.value) &&
        function.endsWith(StockIndicatorKeys.rightBracket.value))) {
      return false;
    }

    return true;
  }

  static double sum(List<double?> data) {
    if (data.isEmpty) {
      return 0;
    }

    return data.reduce((value, element) => (value ?? 0) + (element ?? 0)) ?? 0;
  }

  /// int类型date转成日期
  /// [intDate] int类型日期，例如：20240322
  static DateTime parseIntDateToDateTime(int intDate) {
    var dateStr = intDate.toString();
    int year = int.parse(dateStr.substring(0, 4));
    int month = int.parse(dateStr.substring(4, 6));
    int day = int.parse(dateStr.substring(6, 8));
    return DateTime(year, month, day);
  }
}
