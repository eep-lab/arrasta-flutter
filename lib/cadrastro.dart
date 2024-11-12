import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // Para navegar de volta à MainScreen

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  List<String> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuarios(); // Carregar os cadastros ao iniciar a tela
  }

  // Função para carregar os cadastros salvos
  void _carregarUsuarios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? usuariosSalvos = prefs.getStringList('usuarios');
    if (usuariosSalvos != null) {
      setState(() {
        _usuarios = usuariosSalvos;
      });
    }
  }

  // Função para salvar os cadastros localmente
  void _salvarUsuarios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('usuarios', _usuarios);
  }

  void _adicionarUsuario() {
    String nome = _nomeController.text;
    String idade = _idadeController.text;

    if (nome.isNotEmpty && idade.isNotEmpty && int.tryParse(idade) != null) {
      setState(() {
        _usuarios.add('$nome, $idade anos');
      });
      _nomeController.clear();
      _idadeController.clear();
      _salvarUsuarios(); // Salvar os cadastros após adicionar um novo usuário
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Preencha todos os campos corretamente!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuários'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(_usuarios[index]),
                    onTap: () {
                      String nome = _usuarios[index].split(',')[0];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MainScreen(nomeCadastrado: nome),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: _abrirCadastro,
              backgroundColor: Colors.grey,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _abrirCadastro() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Novo Usuário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _adicionarUsuario,
              child: Text('Cadastrar'),
            ),
          ],
        );
      },
    );
  }
}
