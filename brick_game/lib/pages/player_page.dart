import 'package:flutter/material.dart';

class PlayerPage extends StatelessWidget {
  final player_width;
  final x;

  const PlayerPage({required this.x, required this.player_width, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * x + player_width) / (2 - player_width), 0.9),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 10,
          width: MediaQuery.of(context).size.width * player_width / 2,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
