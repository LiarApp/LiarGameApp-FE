import 'package:flutter/material.dart';

class GameTextStyles {
  static const TextStyle pink = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFF3D81),
  );

  static const TextStyle purple = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF7B61FF),
  );
  
  // 일반 텍스트 ✅
  static const TextStyle normal = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  // 회색 보조 텍스트 ✅
  static const TextStyle gray = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
}