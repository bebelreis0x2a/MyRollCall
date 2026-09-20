import 'package:flutter/material.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({super.key});

  @override
  State<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  int indiceAtual = 0;

  // Controllers para o cadastro de estudantes
  final nomeController = TextEditingController();
  final raController = TextEditingController();
  final blocoController = TextEditingController();

  // Lista simulada em memória (substitui o banco de dados por enquanto)
  final List<Map<String, String>> estudantesCadastrados = [
    {'nome': 'João Silva', 'ra': '12345', 'bloco': 'Bloco A'},
    {'nome': 'Maria Souza', 'ra': '67890', 'bloco': 'Bloco B'},
  ];

  void cadastrarEstudante() {
    if (nomeController.text.isNotEmpty && raController.text.isNotEmpty) {
      setState(() {
        estudantesCadastrados.add({
          'nome': nomeController.text,
          'ra': raController.text,
          'bloco': blocoController.text,
        });
        nomeController.clear();
        raController.clear();
        blocoController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estudante cadastrado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definindo as telas acessadas via NavigationBar
    final List<Widget> paginas = [
      
      // ABA 1: Painel de Ocorrências / Resumo da Chamada
      ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Resumo da Chamada', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.warning, color: Colors.orange),
              title: Text('Pendências de Chamada'),
              subtitle: Text('3 alunos ainda não registraram presença.'),
            ),
          ),
        ],
      ),

      // ABA 2: Lista e Cadastro de Alunos Alojados (Realizado pelo Monitor)
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cadastrar Novo Estudante', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome Completo', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: raController,
              decoration: const InputDecoration(labelText: 'RA / Matrícula', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: blocoController,
              decoration: const InputDecoration(labelText: 'Bloco / Quarto', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cadastrarEstudante,
                child: const Text('Salvar Cadastro'),
              ),
            ),
            const SizedBox(height: 25),
            const Text('Alunos Cadastrados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            // Renderização da lista mantida em memória
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: estudantesCadastrados.length,
              itemBuilder: (context, index) {
                final aluno = estudantesCadastrados[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(aluno['nome'] ?? ''),
                    subtitle: Text('RA: ${aluno['ra']} | ${aluno['bloco']}'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Painel do Monitor')),
      body: paginas[indiceAtual],
      bottomNavigationBar: NavigationBar(
        selectedIndex: indiceAtual,
        onDestinationSelected: (novoIndice) {
          setState(() {
            indiceAtual = novoIndice;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fact_check),
            label: 'Chamada',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add),
            label: 'Cadastrar Alunos',
          ),
        ],
      ),
    );
  }
}