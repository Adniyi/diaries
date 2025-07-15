import 'package:flutter/material.dart';

class NoteActionButtons extends StatelessWidget {
  final Color color;
  final Color iconcolor;
  final IconData icon;
  final void Function()? onTap;
  final double? width;
  const NoteActionButtons({
    super.key,
    required this.color,
    required this.icon,
    this.onTap,
    required this.iconcolor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: iconcolor, size: 30),
      ),
    );
  }
}
