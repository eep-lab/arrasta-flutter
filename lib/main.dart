import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cadrastro.dart'; // Importando o arquivo de cadastro
import 'estimulo1.dart'; // Importando a tela de estímulo
import 'dados.dart'; // Importando a tela de dados

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arrasta Eep',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? nomeCadastrado; // Variável para armazenar o nome do usuário
  bool isButtonEnabled = false; // Verifica se o botão deve estar habilitado

  @override
  void initState() {
    super.initState();
    _carregarNome(); // Carrega o nome cadastrado ao iniciar
  }

  // Função para carregar o nome do usuário de SharedPreferences
  Future<void> _carregarNome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nomeCadastrado = prefs.getString('nomeCadastrado');
      isButtonEnabled = nomeCadastrado !=
          null; // Se nome estiver cadastrado, habilita o botão
    });
  }

  // Função para navegar até a tela de cadastro
  void _irParaCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadrastroScreen()),
    ).then((_) {
      _carregarNome();
    });
  }

  // Função para ir para a tela de estímulo
  void _irParaEstimulo() {
    if (isButtonEnabled) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Estimulo1Screen()),
      );
    }
  }

  // Função para navegar até a tela de dados
  void _irParaDados() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DadosScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arrasta Eep'),
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: _irParaDados,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: _irParaCadastro,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (nomeCadastrado != null)
                Text(
                  nomeCadastrado!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isButtonEnabled
                    ? _irParaEstimulo
                    : null, // Botão só habilitado se o nome for cadastrado
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled
                      ? Color(0xFFD6C7FF)
                      : Colors.grey, // Cor do botão
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Contorno arredondado
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
                child: Text('Começar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
