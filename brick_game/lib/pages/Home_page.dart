import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double x = 0;
  double y = 0;

  void startGame() {
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        y -= 0.01;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startGame,
      child: Scaffold(
        backgroundColor: Colors.deepPurple[200],
        body: Stack(children: [
          Container(
            alignment: Alignment(0, -0.2),
            child: Text(
              'TAP TO START',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment(x, y),
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
