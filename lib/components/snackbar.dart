import 'package:flutter/material.dart';

class MySnackBar extends StatelessWidget {
  const MySnackBar({
    super.key,
    required this.color,
    required this.icon,
    required this.status,
    required this.message,
  });
  final Color color;
  final IconData icon;
  final String status;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Container(
        padding: EdgeInsets.all(16),
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
