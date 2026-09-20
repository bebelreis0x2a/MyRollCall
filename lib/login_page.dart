import 'package:flutter/material.dart';
import 'estudante_page.dart';
import 'monitor_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.badge, size: 80, color: Color(0xFF1B4332)),
              const SizedBox(height: 16),
              const Text(
                'MyRollCall',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Gestão de chamadas nos blocos',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                icon: const Icon(Icons.person),
                label: const Text('Entrar como Estudante'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EstudantePage()),
                  );
                },
              ),
              const SizedBox(height: 12),
              
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text('Entrar como Monitor'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MonitorPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}