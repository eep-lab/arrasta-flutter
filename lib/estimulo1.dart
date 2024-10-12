import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';

class Estimulo1 extends StatefulWidget {
  @override
  _Estimulo1State createState() => _Estimulo1State();
}

class _Estimulo1State extends State<Estimulo1> {
  double bolaAmarelaX = 50;
  double bolaAmarelaY = 50;
  double bolaPretaX = 0; // Variável para posicionamento da bola preta
  double bolaPretaY = 0; // Variável para posicionamento da bola preta
  bool bolaAmarelaEstatica = false;
  bool _cronometroAtivo = true;
  late Timer _timer;
  int _minutes = 0;
  int _seconds = 0;
  int _milliseconds = 0;

  @override
  void initState() {
    super.initState();
    _iniciarCronometro();
  }

  void _iniciarCronometro() {
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (!_cronometroAtivo) return;

      setState(() {
        _milliseconds++;
        if (_milliseconds == 1000) {
          _milliseconds = 0;
          _seconds++;
          if (_seconds == 60) {
            _seconds = 0;
            _minutes++;
          }
        }
      });
    });
  }

  void _pararCronometro() {
    _timer.cancel();
  }

  void _moverBola(DragUpdateDetails details) {
    if (!bolaAmarelaEstatica) {
      setState(() {
        bolaAmarelaX += details.delta.dx;
        bolaAmarelaY += details.delta.dy;
      });

      _verificarColisao();
    }
  }

  void _verificarColisao() {
    // Verifica se as duas bolas estão na mesma posição (com margem de erro)
    if ((bolaAmarelaX - bolaPretaX).abs() < 10 &&
        (bolaAmarelaY - bolaPretaY).abs() < 10) {
      setState(() {
        bolaAmarelaEstatica = true;
        _pararCronometro();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Centralizar a esfera preta
    bolaPretaX = MediaQuery.of(context).size.width / 2 - 50;
    bolaPretaY = MediaQuery.of(context).size.height / 2 - 50;

    return Scaffold(
      body: Stack(
        children: [
          // Esfera preta centralizada
          Positioned(
            left: bolaPretaX,
            top: bolaPretaY,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Esfera amarela
          Positioned(
            left: bolaAmarelaX,
            top: bolaAmarelaY,
            child: GestureDetector(
              onPanUpdate: _moverBola,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: bolaAmarelaEstatica ? Colors.green : Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
              // Transformar a esfera amarela em botão quando estática
              onTap: bolaAmarelaEstatica
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    }
                  : null,
            ),
          ),
          // Cronômetro no canto inferior esquerdo
          Positioned(
            left: 20,
            bottom: 20,
            child: Text(
              '$_minutes:${_seconds.toString().padLeft(2, '0')}:${_milliseconds.toString().padLeft(3, '0')}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
