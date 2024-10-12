import 'package:flutter/material.dart';
import 'nivel1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arrasta',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? _lastTime; // Armazena o tempo do último jogo

  void _navigateToLevel1(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Nivel1()),
    );

    if (result != null) {
      setState(() {
        _lastTime = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arrasta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToLevel1(context),
              child: Text('bloco 1'),
            ),
            if (_lastTime != null) ...[
              SizedBox(height: 20),
              Text(
                'Último tempo: $_lastTime',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
