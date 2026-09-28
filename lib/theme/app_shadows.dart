import 'package:flutter/material.dart';

///  Usage example:
/// `BoxDecoration(boxShadow: ...)`.

abstract final class AppShadows {
  static const List<BoxShadow> xs = [
    BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x0D000000)),
  ];

  static const List<BoxShadow> sm = [
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
      color: Color(0x0F000000),
    ),
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
      color: Color(0x1A000000),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: -2,
      color: Color(0x0D000000),
    ),
    BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
      color: Color(0x1A000000),
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      offset: Offset(0, 8),
      blurRadius: 10,
      spreadRadius: -6,
      color: Color(0x0D000000),
    ),
    BoxShadow(
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
      color: Color(0x1A000000),
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
      color: Color(0x40000000),
    ),
  ];
}
