import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

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
}
