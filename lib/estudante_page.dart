import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'api_service.dart';

class EstudantePage extends StatefulWidget {
  const EstudantePage({super.key});

  @override
  State<EstudantePage> createState() => _EstudantePageState();
}

class _EstudantePageState extends State<EstudantePage> {
  final TextEditingController raController = TextEditingController();
  final TextEditingController blocoController = TextEditingController();

  bool presencaConfirmada = false;
  bool carregando = false;
  String horarioServidor = 'Carregando...';

  @override
  void initState() {
    super.initState();
    buscarHorario();
  }

  Future<void> buscarHorario() async {
    final resultado = await ApiService.obterHorarioOficial();
    if (!mounted) return;
    setState(() {
      if (resultado.sucesso) {
        horarioServidor = '${resultado.horaFormatada} (Horário Oficial)';
      } else {
        horarioServidor = 'Offline (Erro ao buscar hora)';
      }
    });
  }

  Future<void> registrarPresenca() async {
    if (raController.text.isEmpty || blocoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o RA e o Bloco antes de confirmar.')),
      );
      return;
    }

    setState(() => carregando = true);

    try {
      final dadosHora = await ApiService.obterHorarioOficial();
      if (!dadosHora.sucesso) {
        throw Exception(dadosHora.erro);
      }

      /* Descomente para ativar a trava real de horário (22h30 às 23h00):
      if (dadosHora.hora != 22 || dadosHora.minuto < 30) {
        throw Exception('Fora da janela de chamada (22h30 às 23h00). Agora são ${dadosHora.horaFormatada}.');
      }
      */

      await FirebaseFirestore.instance.collection('chamadas').add({
        'ra': raController.text.trim(),
        'bloco': blocoController.text.trim(),
        'horario': dadosHora.horaFormatada,
        'data': FieldValue.serverTimestamp(),
      });

      setState(() {
        presencaConfirmada = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chamada Noturna')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Confirmar Presença', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Janela: 22h30 às 23h00 | Agora: $horarioServidor', style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 20),
            TextField(
              controller: raController,
              decoration: const InputDecoration(
                labelText: 'RA do Estudante',
                prefixIcon: Icon(Icons.assignment_ind),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: blocoController,
              decoration: const InputDecoration(
                labelText: 'Bloco / Alojamento',
                prefixIcon: Icon(Icons.apartment),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: carregando ? null : registrarPresenca,
                icon: carregando
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.check_circle),
                label: Text(carregando ? 'Registrando...' : 'Marcar Presença'),
              ),
            ),
            const SizedBox(height: 30),
            if (presencaConfirmada)
              Card(
                color: Colors.green.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Presença sincronizada com o Firebase!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}