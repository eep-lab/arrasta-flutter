import 'package:flutter/material.dart';
import 'cadrastro.dart';
import 'estimulo1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String nomeCadastrado;

  MainScreen({this.nomeCadastrado = ''});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _nomeCadastrado = '';
  bool _cadastrado = false;

  @override
  void initState() {
    super.initState();
    if (widget.nomeCadastrado.isNotEmpty) {
      _nomeCadastrado = widget.nomeCadastrado;
      _cadastrado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _cadastrado
                    ? Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        child: Text(
                          _nomeCadastrado,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : Text('nenhum cadastro realizado'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _cadastrado
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Estimulo1()),
                          );
                        }
                      : null,
                  child: Text('estímulo 1'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.person, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadrastroScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
