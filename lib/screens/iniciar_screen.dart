import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class IniciarScreen extends StatelessWidget {
  const IniciarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // FUNDO DA TELA
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

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),

            child: Column(
              children: [

                // BOTÃO LOGIN NO TOPO
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.15),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },

                    icon: const Icon(Icons.login),

                    label: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // CONTEÚDO CENTRAL
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          /// LOGO
                          Container(
                            width: 220,
                            height: 220,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.asset(
                              'assets/images/safeneighbor_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// NOME DO APP
                          const Text(
                            'SafeNeighbor',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 32),

                          /// DESCRIÇÃO
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),

                            child: const Text(
                              'O SafeNeighbor é um aplicativo que informa, em tempo real, incidentes como assaltos, incêndios e acidentes na sua região. Com base na sua localização, ajuda a evitar áreas de risco e oferece um botão de emergência para acionar a polícia rapidamente, garantindo mais segurança para você e sua família.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 48),

                          /// BOTÃO MAPA
                          CustomButton(
                            text: 'Mapa',
                            onPressed: () {

                              // ALERTA DE LOGIN
                              showDialog(
                                context: context,
                                builder: (context) {

                                  return AlertDialog(
                                    title: const Text(
                                      'Acesso Necessário',
                                    ),

                                    content: const Text(
                                      'Você precisa fazer login ou criar uma conta para acessar o mapa.',
                                    ),

                                    actions: [

                                      /// BOTÃO LOGIN
                                      TextButton(
                                        onPressed: () {

                                          Navigator.pop(context);

                                          Navigator.pushNamed(
                                            context,
                                            '/login',
                                          );
                                        },

                                        child: const Text(
                                          'Ir para Login',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}