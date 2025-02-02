import 'package:flutter/material.dart';

class BallPage extends StatelessWidget {
  final double x;
  final double y;

  const BallPage({required this.x, required this.y, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(x, y),
      child: Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
