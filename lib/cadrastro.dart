import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadrastroScreen extends StatefulWidget {
  @override
  _CadrastroScreenState createState() => _CadrastroScreenState();
}

class _CadrastroScreenState extends State<CadrastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  List<Map<String, String>> usuarios = [];
  String unidadeIdade = "ano(s)"; // Unidade padrão para idade

  @override
  void initState() {
    super.initState();
    _carregarUsuarios(); // Carrega os usuários salvos ao iniciar
  }

  // Função para salvar os usuários no SharedPreferences
  Future<void> _salvarUsuarios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listaSerializada = usuarios
        .map((usuario) => "${usuario['nome']},${usuario['idade']}")
        .toList();
    await prefs.setStringList('usuarios', listaSerializada);
  }

  // Função para carregar os usuários do SharedPreferences
  Future<void> _carregarUsuarios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? listaSerializada = prefs.getStringList('usuarios');
    if (listaSerializada != null) {
      setState(() {
        usuarios = listaSerializada.map((string) {
          List<String> partes = string.split(',');
          return {'nome': partes[0], 'idade': partes[1]};
        }).toList();
      });
    }
  }

  // Função para adicionar um novo usuário
  void _adicionarUsuario() {
    if (_nomeController.text.isEmpty || _idadeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, preencha todos os campos!'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Validação da idade
    int? idade = int.tryParse(_idadeController.text);
    if (idade == null || idade <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Idade deve ser um número inteiro maior que 0!'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      usuarios.add({
        'nome': _nomeController.text,
        'idade': '${_idadeController.text} $unidadeIdade',
      });
    });

    _salvarUsuarios(); // Salva os usuários no SharedPreferences
    _nomeController.clear();
    _idadeController.clear();
  }

  // Função para exibir os usuários cadastrados
  Widget _mostrarUsuarios() {
    return ListView.builder(
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _selecionarUsuario(usuarios[index]['nome']!),
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                '${usuarios[index]['nome']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Idade: ${usuarios[index]['idade']}'),
            ),
          ),
        );
      },
    );
  }

  // Função para selecionar um usuário e voltar para a tela principal
  Future<void> _selecionarUsuario(String nome) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'nomeCadastrado', nome); // Salva o nome no SharedPreferences
    Navigator.pop(context); // Retorna à tela principal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuários'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD6C7FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _idadeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Idade',
                        border: OutlineInputBorder(),
                        suffixIcon: PopupMenuButton<String>(
                          icon: Icon(Icons.arrow_drop_down),
                          onSelected: (value) {
                            setState(() {
                              unidadeIdade = value;
                            });
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: "ano(s)",
                              child: Text('ano(s)'),
                            ),
                            PopupMenuItem(
                              value: "mês(es)",
                              child: Text('mês(es)'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    unidadeIdade,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _adicionarUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD6C7FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Adicionar Usuário'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _mostrarUsuarios(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
