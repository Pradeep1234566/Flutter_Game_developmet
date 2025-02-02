import 'dart:async';

import 'package:brick_game/pages/ball_page.dart';
import 'package:brick_game/pages/cover_page.dart';
import 'package:brick_game/pages/player_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double x = 0;
  double y = 0;
  bool IsGameStarted = false;
  double player_width = 0.3;
  double player_x = 0;

  void startGame() {
    IsGameStarted = true;
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
          CoverPage(isGameStarted: IsGameStarted),
          BallPage(x: x, y: y),
          PlayerPage(player_width: player_width, x: player_x),
        ]),
      ),
    );
  }
}
