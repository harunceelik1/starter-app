import 'package:flutter/material.dart';

class MyPadding {
  static const EdgeInsets all = EdgeInsets.all(20);
  static const EdgeInsets all8 = EdgeInsets.all(8);

  static const EdgeInsets horizontal20 = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets horizontal8 = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets horizontal25 = EdgeInsets.symmetric(horizontal: 25);
  static const EdgeInsets horizontal12 = EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets showPadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 5);

  static const EdgeInsets vertical10 = EdgeInsets.symmetric(vertical: 10.0);

  static const EdgeInsets inputLeftRight = EdgeInsets.only(left: 20, right: 20);
  static const EdgeInsets inputLeftRightBottom =
      EdgeInsets.only(left: 20, right: 20, bottom: 10);
}
