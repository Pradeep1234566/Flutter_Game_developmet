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

  // Game state
  bool isGameStarted = false;

  // Player parameters
  double player_width = 0.3; // Width of the player paddle
  double player_x = 0; // Player's x position

  // Movement sensitivity (smaller = less sensitive)
  final double movementSensitivity = 0.04; // Reduced sensitivity

  // Starts the game and initiates ball movement
  void startGame() {
    setState(() {
      isGameStarted = true;
    });

    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        y -= 0.01; // Ball movement speed
      });
    });
  }

  // Moves the player paddle to the left
  void moveLeft() {
    setState(() {
      // Check if movement won't exceed left boundary (-1)
      if (player_x - movementSensitivity >= -1) {
        player_x -= movementSensitivity;
      }
    });
  }

  // Moves the player paddle to the right
  void moveRight() {
    setState(() {
      // Check if movement won't exceed right boundary (1 - paddle width)
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
          // Handle horizontal drag movements
          double velocity = details.primaryDelta ?? 0;

          // Control the speed of the movement based on the drag velocity
          if (velocity > 0) {
            moveRight();
          } else if (velocity < 0) {
            moveLeft();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.deepPurple[200],
          body: Stack(children: [
            CoverPage(isGameStarted: isGameStarted),
            BallPage(x: x, y: y),
            PlayerPage(player_width: player_width, x: player_x),
          ]),
        ),
      ),
    );
  }
}
