import 'package:flutter/material.dart';

class CoverPage extends StatelessWidget {
  final bool isGameStarted;

  const CoverPage({required this.isGameStarted});

  @override
  Widget build(BuildContext context) {
    return isGameStarted
        ? Container()
        : Container(
            alignment: Alignment(0, -0.2),
            child: Text(
              'TAP TO START',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20,
              ),
            ),
          );
  }
}
