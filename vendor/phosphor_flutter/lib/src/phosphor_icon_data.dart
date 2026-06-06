library phosphor_flutter;

// ignore_for_file: non_const_argument_for_const_parameter

import 'package:flutter/widgets.dart';

class PhosphorIconData {
  const PhosphorIconData(this.codePoint, this.style);

  final int codePoint;
  final String style;

  IconData get iconData => IconData(
        codePoint,
        fontFamily: 'Phosphor$style',
        fontPackage: 'phosphor_flutter',
        matchTextDirection: true,
      );
}

class PhosphorFlatIconData extends PhosphorIconData {
  const PhosphorFlatIconData(int codePoint, String style) : super(codePoint, style);
}

class PhosphorDuotoneIconData extends PhosphorIconData {
  const PhosphorDuotoneIconData(int codePoint, this.secondary) : super(codePoint, 'Duotone');

  final PhosphorIconData secondary;
}
