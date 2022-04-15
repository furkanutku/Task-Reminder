import 'package:flutter/material.dart';
import 'package:task_reminder/ui/theme.dart';

class MyButton extends StatelessWidget {
  MyButton(
      {required this.label,
      required this.onTap,
      this.width,
      required this.color});

  final String label;
  final Function()? onTap;
  final double? width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
