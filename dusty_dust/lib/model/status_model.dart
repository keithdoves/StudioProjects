

import 'package:flutter/material.dart';

class StatusModel{
  // 단계
  final int level;
  // 단계이름
  final String label;
  // 주색상
  final Color primaryColor;
  // 어두운 색상
  final Color darkColor;
  // 밝은 색상
final Color lightColor;
final Color fontColor;
final String imagePath;
final String comment;
// 미세먼지 최소치
final double minPM10;
final double minPM25;
final double minO3;
final double MinNO2;
final double minCO;
final double minSO2;

  const StatusModel({
    required this.level,
    required this.label,
    required this.primaryColor,
    required this.darkColor,
    required this.lightColor,
    required this.fontColor,
    required this.imagePath,
    required this.comment,
    required this.minPM10,
    required this.minPM25,
    required this.minO3,
    required this.MinNO2,
    required this.minCO,
    required this.minSO2,
});


}