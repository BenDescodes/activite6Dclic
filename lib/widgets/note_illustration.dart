import 'package:flutter/material.dart';

class NoteIllustration extends StatelessWidget {
  final double size;

  const NoteIllustration({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Icon(Icons.edit_note, size: 82, color: Color(0xFF2563EB)),
    );
  }
}
