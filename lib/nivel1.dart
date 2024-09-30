import 'package:flutter/material.dart';
import 'dart:async';

class Nivel1 extends StatefulWidget {
  @override
  _Nivel1State createState() => _Nivel1State();
}

class _Nivel1State extends State<Nivel1> {
  Offset _position = Offset(100, 100); // Posição inicial da bola amarela
  late Timer _timer;
  int _elapsedTime = 0;
  bool _isGameOver = false;
  bool _isInTarget = false; // Verifica se a bola amarela está no alvo

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!_isGameOver) {
        setState(() {
          _elapsedTime++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _returnToMain() {
    Navigator.pop(context,
        'Tempo: ${(_elapsedTime ~/ 10).toString().padLeft(2, '0')}:${(_elapsedTime % 10).toString().padLeft(2, '0')}');
  }

  void _stopTimerAndReturn() {
    setState(() {
      _isGameOver = true;
    });
    _timer.cancel();
    _returnToMain();
  }

  bool _checkIfInTarget() {
    // Verifica se a bola amarela está exatamente sobre o botão preto
    double targetX = MediaQuery.of(context).size.width / 2 - 50;
    double targetY = MediaQuery.of(context).size.height / 1.5 - 50;

    return (_position.dx >= targetX && _position.dx <= targetX + 10) &&
        (_position.dy >= targetY && _position.dy <= targetY + 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MouseRegion(
        onHover: (event) {
          if (!_isInTarget) {
            setState(() {
              _position = event.position -
                  Offset(45, 45); // Move a bola com base no mouse
            });
            if (_checkIfInTarget()) {
              setState(() {
                _isInTarget = true; // Marca que a bola está no alvo
                _position = Offset(
                  MediaQuery.of(context).size.width / 2 - 45,
                  MediaQuery.of(context).size.height / 1.5 - 45,
                ); // Posiciona exatamente sobre o botão preto
              });
            }
          }
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                ': ${(_elapsedTime ~/ 10).toString().padLeft(2, '0')}:${(_elapsedTime % 10).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _stopTimerAndReturn,
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), backgroundColor: Colors.black,
                  padding: EdgeInsets.all(60), // Cor preta do alvo
                ),
                child: null,
              ),
            ),
            Positioned(
              left: _position.dx,
              top: _position.dy,
              child: GestureDetector(
                onTap: _isInTarget
                    ? _stopTimerAndReturn
                    : null, // Bola clicável no alvo
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
