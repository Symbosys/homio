import 'package:flutter/material.dart';

/// Border radius tokens for consistent corner geometry.
class AppRadius {
  AppRadius._();

  static const double xsVal = 4;
  static const double smVal = 6;
  static const double mdVal = 10;
  static const double lgVal = 16;
  static const double xlVal = 24;
  static const double fullVal = 999;

  static const BorderRadius xs = BorderRadius.all(Radius.circular(xsVal));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(smVal));
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdVal));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgVal));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlVal));
  static const BorderRadius full = BorderRadius.all(Radius.circular(fullVal));
}

/// Convenience OutlinedBorder shapes corresponding to AppRadius tokens.
class RoundedAppRadius {
  RoundedAppRadius._();

  static const RoundedRectangleBorder xs = RoundedRectangleBorder(borderRadius: AppRadius.xs);
  static const RoundedRectangleBorder sm = RoundedRectangleBorder(borderRadius: AppRadius.sm);
  static const RoundedRectangleBorder md = RoundedRectangleBorder(borderRadius: AppRadius.md);
  static const RoundedRectangleBorder lg = RoundedRectangleBorder(borderRadius: AppRadius.lg);
  static const RoundedRectangleBorder xl = RoundedRectangleBorder(borderRadius: AppRadius.xl);
  static const RoundedRectangleBorder full = RoundedRectangleBorder(borderRadius: AppRadius.full);
}

