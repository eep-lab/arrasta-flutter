import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DadosScreen extends StatefulWidget {
  @override
  _DadosScreenState createState() => _DadosScreenState();
}

class _DadosScreenState extends State<DadosScreen> {
  List<String> nomesCadastrados = [];

  // Função para carregar os nomes dos usuários cadastrados
  Future<void> _carregarDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nomesCadastrados = prefs.getStringList('usuarios') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explorador de Usuários'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: nomesCadastrados.isEmpty
            ? Center(
                child: Text(
                  'Nenhum usuário cadastrado',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Define o número de colunas
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: nomesCadastrados.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Ação ao clicar na pasta
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Pasta do usuário "${nomesCadastrados[index]}" selecionada!'),
                      ));
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.folder,
                          size: 60,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          nomesCadastrados[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
