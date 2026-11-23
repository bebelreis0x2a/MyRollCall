import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'database_helper.dart';
import 'estudante_model.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({super.key});

  @override
  State<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  int indiceAtual = 0;

  final nomeController = TextEditingController();
  final raController = TextEditingController();
  final blocoController = TextEditingController();

  List<Estudante> estudantesSQLite = [];

  @override
  void initState() {
    super.initState();
    carregarEstudantesLocais();
  }

  Future<void> carregarEstudantesLocais() async {
    try {
      final lista = await DatabaseHelper.instance.listarEstudantes();
      if (!mounted) return;
      setState(() {
        estudantesSQLite = lista;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao ler banco local: $e')),
        );
      }
    }
  }

  Future<void> cadastrarEstudante() async {
    if (nomeController.text.isEmpty || raController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha pelo menos Nome e RA.')),
      );
      return;
    }

    try {
      final novoAluno = Estudante(
        nome: nomeController.text.trim(),
        ra: raController.text.trim(),
        bloco: blocoController.text.trim(),
      );

      await DatabaseHelper.instance.inserirEstudante(novoAluno);

      nomeController.clear();
      raController.clear();
      blocoController.clear();

      await carregarEstudantesLocais();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salvo no banco SQLite com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar no SQLite: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> paginas = [
      // ABA 1: Presenças em tempo real vindas do Firebase Firestore
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Presenças Registradas (Firebase)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chamadas')
                    .orderBy('data', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar dados do Firebase.'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(child: Text('Nenhuma presença registrada ainda.'));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final dados = docs[index].data() as Map<String, Object?>;
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.check_circle, color: Colors.green),
                          title: Text('RA: ${dados['ra']} - ${dados['bloco']}'),
                          subtitle: Text('Registrado às ${dados['horario'] ?? '--:--'}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ABA 2: Cadastro de Alunos Alojados persistido no SQLite
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cadastrar Estudante (SQLite)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                child: const Text('Salvar no SQLite'),
              ),
            ),
            const SizedBox(height: 25),
            const Text('Alunos Cadastrados Localmente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: estudantesSQLite.length,
              itemBuilder: (context, index) {
                final aluno = estudantesSQLite[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.storage),
                    title: Text(aluno.nome),
                    subtitle: Text('RA: ${aluno.ra} | ${aluno.bloco}'),
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
            icon: Icon(Icons.cloud_done),
            label: 'Chamada (Nuvem)',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add),
            label: 'Cadastro (SQLite)',
          ),
        ],
      ),
    );
  }
}