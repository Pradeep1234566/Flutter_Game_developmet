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
  // Ball position coordinates
  double x = 0;
  double y = 0;
  double ballDirection = -1; // -1 for up, 1 for down

  // Game state
  bool isGameStarted = false;

  // Player parameters
  double player_width = 0.3;
  double player_x = 0;

  final double movementSensitivity = 0.04;

  void startGame() {
    setState(() {
      isGameStarted = true;
    });

    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        // Move ball up or down based on direction
        y += 0.01 * ballDirection;

        // Reverse direction when hitting top or bottom
        if (y <= -1) {
          ballDirection = 1; // Start moving down
        }
        if (y >= 0.9) {
          ballDirection = -1; // Start moving up
        }
      });
    });
  }

  void moveLeft() {
    setState(() {
      if (player_x - movementSensitivity >= -1) {
        player_x -= movementSensitivity;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (player_x + movementSensitivity <= 1 - player_width) {
        player_x += movementSensitivity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      child: GestureDetector(
        onTap: startGame,
        onHorizontalDragUpdate: (details) {
          double velocity = details.primaryDelta ?? 0;
          if (velocity > 0) {
            moveRight();
          } else if (velocity < 0) {
            moveLeft();
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.deepPurple[200],
            body: Stack(children: [
              CoverPage(isGameStarted: isGameStarted),
              BallPage(x: x, y: y),
              PlayerPage(player_width: player_width, x: player_x),
            ]),
          ),
        ),
      ),
    );
  }
}
