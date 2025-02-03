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

  // Bricks
  List<Brick> bricks = [];

  @override
  void initState() {
    super.initState();
    createBricks();
  }

  void createBricks() {
    bricks = List.generate(5, (i) {
      return Brick(x: -0.9 + i * 0.45, y: -0.5);
    });
  }

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

        // Check for collision with bricks
        for (var brick in bricks) {
          if (brick.isHit(x, y)) {
            ballDirectionY *= -1;
            bricks.remove(brick);
            break;
          }
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
              ...bricks
                  .map((brick) => Positioned(
                        left: (brick.x + 1) *
                            MediaQuery.of(context).size.width /
                            2,
                        top: (brick.y + 1) *
                            MediaQuery.of(context).size.height /
                            2,
                        child: Container(
                          width: 100,
                          height: 20,
                          color: Colors.red,
                        ),
                      ))
                  .toList(),
            ]),
          ),
        ),
      ),
    );
  }
}

class Brick {
  double x;
  double y;

  Brick({required this.x, required this.y});

  bool isHit(double ballX, double ballY) {
    return (ballX >= x && ballX <= x + 0.2) && (ballY >= y && ballY <= y + 0.1);
  }
}
