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
  double ballDirectionX = 1; // 1 for right, -1 for left
  double ballDirectionY = -1; // -1 for up, 1 for down

  // Game state
  bool isGameStarted = false;

  // Player parameters
  double playerWidth = 0.3;
  double playerX = 0;

  final double movementSensitivity = 0.02;

  void startGame() {
    setState(() {
      isGameStarted = true;
    });

    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        // Move ball based on direction
        x += 0.01 * ballDirectionX;
        y += 0.01 * ballDirectionY;

        // Reverse direction when hitting top or bottom
        if (y <= -1) {
          ballDirectionY = 1; // Start moving down
        }
        if (y >= 0.9) {
          // Check if ball is within player width
          if (x >= playerX && x <= playerX + playerWidth) {
            ballDirectionY = -1; // Start moving up
          } else {
            // Game over or reset ball position
            timer.cancel();
            isGameStarted = false;
          }
        }

        // Reverse direction when hitting sides
        if (x <= -1 || x >= 1) {
          ballDirectionX *= -1;
        }
      });
    });
  }

  void moveLeft() {
    setState(() {
      if (playerX - movementSensitivity >= -1) {
        playerX -= movementSensitivity;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + movementSensitivity <= 1 - playerWidth) {
        playerX += movementSensitivity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
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
              PlayerPage(player_width: playerWidth, x: playerX),
            ]),
          ),
        ),
      ),
    );
  }
}
