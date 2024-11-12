import 'package:flutter/material.dart';
import 'cadrastro.dart';
import 'estimulo1.dart';
import 'dados.dart'; // Importa a tela DadosScreen

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
      appBar: AppBar(
        title: Text('EEP arrasta'),
        leading: IconButton(
          icon: Icon(Icons.search), // Ícone da lupa no canto superior esquerdo
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DadosScreen()), // Navegação para a tela de dados
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person,
                size: 30), // Ícone de pessoa no canto superior direito
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CadastroScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
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
                : Text('Nenhum cadastro realizado'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cadastrado
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Estimulo1()),
                      );
                    }
                  : null,
              child: Text('Estímulo 1'),
            ),
          ],
        ),
      ),
    );
  }
}

// DadosScreen - Tela com a planilha
class DadosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planilha Vazia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 2,
          ),
          itemCount: 50, // Total de células
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          },
        ),
      ),
    );
  }
}
