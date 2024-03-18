import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(GunGame());
}

class GunGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final double playerSize = 50.0;
  final double bulletSize = 10.0;
  final double enemySize = 50.0;
  final double enemySpeed = 3.0;

  double playerX = 0;
  double playerY = 0;
  double bulletX = 0;
  double bulletY = 0;
  double enemyX = 0;
  double enemyY = 0;
  int score = 0;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    playerX = 0;
    playerY = 0;
    bulletX = -100;
    bulletY = -100;
    enemyX = 400;
    enemyY = 200;
    score = 0;
    timer = Timer.periodic(Duration(milliseconds: 20), (ticmer) {
      setState(() {
        moveEnemy();
        moveBullet();
        checkCollision();
      });
    });
  }

  void moveEnemy() {
    if (enemyX < playerX) {
      enemyX += enemySpeed;
    } else {
      enemyX -= enemySpeed;
    }
    if (enemyY < playerY) {
      enemyY += enemySpeed;
    } else {
      enemyY -= enemySpeed;
    }
  }

  void moveBullet() {
    if (bulletX >= 0 && bulletY >= 0) {
      bulletX += 10;
      if (bulletX > 600 || bulletY > 400) {
        bulletX = -100;
        bulletY = -100;
      }
    }
  }

  void checkCollision() {
    if ((bulletX >= enemyX && bulletX <= enemyX + enemySize) &&
        (bulletY >= enemyY && bulletY <= enemyY + enemySize)) {
      score++;
      bulletX = -100;
      bulletY = -100;
      enemyX = Random().nextInt(500).toDouble();
      enemyY = Random().nextInt(300).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gun Game'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            playerX += details.delta.dx;
            playerY += details.delta.dy;
          });
        },
        child: Stack(
          children: [
            Positioned(
              left: playerX,
              top: playerY,
              child: Container(
                width: playerSize,
                height: playerSize,
                color: Colors.blue,
              ),
            ),
            Positioned(
              left: bulletX,
              top: bulletY,
              child: Container(
                width: bulletSize,
                height: bulletSize,
                color: Colors.red,
              ),
            ),
            Positioned(
              left: enemyX,
              top: enemyY,
              child: Container(
                width: enemySize,
                height: enemySize,
                color: Colors.green,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Text(
                'Score: $score',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
