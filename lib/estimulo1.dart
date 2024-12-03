import 'package:flutter/material.dart';
import 'dart:async';

class Estimulo1Screen extends StatefulWidget {
  @override
  _Estimulo1ScreenState createState() => _Estimulo1ScreenState();
}

class _Estimulo1ScreenState extends State<Estimulo1Screen> {
  Offset _bolaAmarelaPos = Offset(150, 150);
  bool _cronometroAtivo = false;
  bool _esferasSobrepostas = false;
  Timer? _cronometro;
  Duration _tempo = Duration.zero;

  void _iniciarCronometro() {
    if (!_cronometroAtivo) {
      _cronometroAtivo = true;
      _cronometro = Timer.periodic(Duration(milliseconds: 10), (timer) {
        setState(() {
          _tempo += Duration(milliseconds: 10);
        });
      });
    }
  }

  void _pararCronometro() {
    if (_cronometroAtivo) {
      _cronometroAtivo = false;
      _cronometro?.cancel();
    }
  }

  bool _bolasSeSobrepoem(Offset bolaPretaPos, double tamanho) {
    return (_bolaAmarelaPos.dx - bolaPretaPos.dx).abs() < tamanho &&
        (_bolaAmarelaPos.dy - bolaPretaPos.dy).abs() < tamanho;
  }

  @override
  Widget build(BuildContext context) {
    double tamanhoBola = 80.0;
    Offset bolaPretaPos = Offset(
        MediaQuery.of(context).size.width / 2 - tamanhoBola / 2,
        MediaQuery.of(context).size.height / 2 - tamanhoBola / 2);

    return Scaffold(
      body: Stack(
        children: [
          // Bola preta estática
          Positioned(
            left: bolaPretaPos.dx,
            top: bolaPretaPos.dy,
            child: GestureDetector(
              onTap: () {
                if (_esferasSobrepostas) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: tamanhoBola,
                height: tamanhoBola,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // Bola amarela móvel
          Positioned(
            left: _bolaAmarelaPos.dx,
            top: _bolaAmarelaPos.dy,
            child: GestureDetector(
              onPanStart: (details) {
                if (!_esferasSobrepostas) {
                  _iniciarCronometro();
                }
              },
              onPanUpdate: (details) {
                if (!_esferasSobrepostas) {
                  setState(() {
                    _bolaAmarelaPos = Offset(
                      _bolaAmarelaPos.dx + details.delta.dx,
                      _bolaAmarelaPos.dy + details.delta.dy,
                    );
                  });

                  if (_bolasSeSobrepoem(bolaPretaPos, tamanhoBola)) {
                    setState(() {
                      _esferasSobrepostas = true;
                      _bolaAmarelaPos = bolaPretaPos;
                    });
                    _pararCronometro();
                  }
                }
              },
              child: Container(
                width: tamanhoBola,
                height: tamanhoBola,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // Cronômetro no canto inferior
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              '${_tempo.inMinutes.toString().padLeft(2, '0')}:'
              '${(_tempo.inSeconds % 60).toString().padLeft(2, '0')}:'
              '${(_tempo.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Botão de retorno à main (aparece após as bolas se sobreporem)
          if (_esferasSobrepostas)
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.refresh, size: 30, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cronometro?.cancel();
    super.dispose();
  }
}
