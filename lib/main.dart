import 'package:flutter/material.dart';
import 'screens/cadastro_screen.dart';
import 'screens/iniciar_screen.dart';
import 'screens/login_screen.dart';
import 'screens/info_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/mapa_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// TELA INICIAL
      initialRoute: '/',

      routes: {
        '/': (context) => const IniciarScreen(),
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/info': (context) => const InfoScreen(),
        '/chat': (context) => const ChatScreen(),
        '/mapa': (context) => const MapaScreen(),
      },
    );
  }
}