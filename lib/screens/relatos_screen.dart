import 'package:flutter/material.dart';

class RelatosScreen extends StatelessWidget {
  const RelatosScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Relatos'),
        backgroundColor: const Color(0xFF1E3A8A),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF0F172A),
            ],
          ),
        ),

        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [

            relatoCard(
              titulo: 'Assalto',
              descricao:
                  'Dois homens roubaram celulares perto da praça.',
              local: 'Centro',
              horario: '10 min atrás',
              cor: Colors.red,
              icone: Icons.warning,
            ),

            const SizedBox(height: 16),

            relatoCard(
              titulo: 'Acidente',
              descricao:
                  'Batida entre carros causando trânsito.',
              local: 'Av. Brasil',
              horario: '25 min atrás',
              cor: Colors.orange,
              icone: Icons.car_crash,
            ),
          ],
        ),
      ),
    );
  }

  Widget relatoCard({
    required String titulo,
    required String descricao,
    required String local,
    required String horario,
    required Color cor,
    required IconData icone,
  }) {

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Icon(
                icone,
                color: cor,
              ),

              const SizedBox(width: 8),

              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            descricao,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              const Icon(
                Icons.location_on,
                color: Colors.white70,
                size: 18,
              ),

              const SizedBox(width: 4),

              Text(
                local,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),

              const Spacer(),

              Text(
                horario,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}