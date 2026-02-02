import 'package:flutter/material.dart';

class RoleChip extends StatelessWidget {
  final String text;
  final bool isLiar;

  const RoleChip({
    super.key,
    required this.text,
    required this.isLiar,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor:
          isLiar ? const Color(0xFFFF3D81) : const Color(0xFF7B61FF),
    );
  }
}
