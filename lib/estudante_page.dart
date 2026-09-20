import 'package:flutter/material.dart';

class EstudantePage extends StatefulWidget {
  const EstudantePage({super.key});

  @override
  State<EstudantePage> createState() => _EstudantePageState();
}

class _EstudantePageState extends State<EstudantePage> {
  final TextEditingController raController = TextEditingController();
  final TextEditingController blocoController = TextEditingController();
  bool presencaConfirmada = false;

  void registrarPresenca() {
    if (raController.text.isNotEmpty && blocoController.text.isNotEmpty) {
      setState(() {
        presencaConfirmada = true;
      });
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
            Text('Janela de registro: 22h30 às 23h00', style: TextStyle(color: Colors.grey.shade600)),
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
                onPressed: registrarPresenca,
                icon: const Icon(Icons.check_circle),
                label: const Text('Marcar Presença'),
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
                      Text('Presença registrada com sucesso!', style: TextStyle(fontWeight: FontWeight.bold)),
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