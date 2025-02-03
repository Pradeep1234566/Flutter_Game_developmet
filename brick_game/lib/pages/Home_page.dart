import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double x = 0, y = 0;
  double ballDirectionX = 1,
      ballDirectionY = 1; // Changed to make the ball fall down initially
  bool isGameStarted = false;
  double playerWidth = 0.05;
  double playerX = 0;
  final double movementSensitivity = 0.05;
  List<Brick> bricks = [];

  @override
  void initState() {
    super.initState();
    createBricks();
  }

  void createBricks() {
    bricks = [];
    for (double i = -0.9; i < 0.9; i += 0.3) {
      for (double j = -0.6; j < -0.2; j += 0.15) {
        bricks.add(Brick(x: i, y: j));
      }
    }
  }

  void startGame() {
    setState(() => isGameStarted = true);
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        x += 0.01 * ballDirectionX;
        y += 0.01 * ballDirectionY;

        if (y <= -1) ballDirectionY = 1;
        if (y >= 0.9) {
          if (x >= playerX && x <= playerX + playerWidth) {
            ballDirectionY = -1;
          } else {
            timer.cancel();
            isGameStarted = false;
          }
        }
        if (x <= -1 || x >= 1) ballDirectionX *= -1;
        bricks.removeWhere((brick) {
          if (brick.isHit(x, y)) {
            ballDirectionY *= -1;
            return true;
          }
          return false;
        });
      });
    });
  }

  void moveLeft() {
    setState(() =>
        playerX = (playerX - movementSensitivity).clamp(-1, 1 - playerWidth));
  }

  void moveRight() {
    setState(() =>
        playerX = (playerX + movementSensitivity).clamp(-1, 1 - playerWidth));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: startGame,
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            moveRight();
          } else {
            moveLeft();
          }
        },
        child: Stack(children: [
          if (!isGameStarted)
            Center(
                child: Text("Tap to Start",
                    style: TextStyle(color: Colors.white, fontSize: 24))),
          Positioned(
            left: (x + 1) * MediaQuery.of(context).size.width / 2,
            top: (y + 1) * MediaQuery.of(context).size.height / 2,
            child: Container(
                width: 15,
                height: 15,
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
          ),
          Positioned(
            left: (playerX + 1) * MediaQuery.of(context).size.width / 2,
            bottom: 50,
            child: Container(
                width: MediaQuery.of(context).size.width * playerWidth,
                height: 15,
                color: Colors.blue),
          ),
          ...bricks.map((brick) => Positioned(
                left: (brick.x + 1) * MediaQuery.of(context).size.width / 2,
                top: (brick.y + 1) * MediaQuery.of(context).size.height / 2,
                child: Container(
                    width: 80,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5))),
              ))
        ]),
      ),
    );
  }
}

class Brick {
  double x, y;
  Brick({required this.x, required this.y});
  bool isHit(double ballX, double ballY) {
    return (ballX >= x && ballX <= x + 0.2) && (ballY >= y && ballY <= y + 0.1);
  }
}
