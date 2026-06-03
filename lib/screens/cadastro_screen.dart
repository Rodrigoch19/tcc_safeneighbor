import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() =>
      _CadastroScreenState();
}

class _CadastroScreenState
    extends State<CadastroScreen> {

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController =
      TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();

    super.dispose();
  }

  void _cadastrar() {

    /// VALIDAÇÃO NOME
    if (_nomeController.text.trim().isEmpty) {
      _showMessage('Preencha o campo de nome');
      return;
    }

    /// VALIDAÇÃO EMAIL
    if (_emailController.text.trim().isEmpty) {
      _showMessage('Preencha o campo de email');
      return;
    }

    /// VALIDAÇÃO SENHA
    if (_senhaController.text.isEmpty) {
      _showMessage('Preencha o campo de senha');
      return;
    }

    /// CONFIRMAR SENHA
    if (_confirmarSenhaController.text.isEmpty) {
      _showMessage('Confirme sua senha');
      return;
    }

    /// SENHAS DIFERENTES
    if (_senhaController.text !=
        _confirmarSenhaController.text) {
      _showMessage('As senhas não coincidem');
      return;
    }

    /// SUCESSO
    Navigator.pushNamed(context, '/info');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Container(
                    width: 150,
                    height: 150,
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

                  /// TÍTULO
                  const Text(
                    'SafeNeighbor',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// SUBTÍTULO
                  const Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 48),

                  /// NOME
                  CustomTextField(
                    controller: _nomeController,
                    hintText: 'Nome',
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 16),

                  /// EMAIL
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType:
                        TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  /// SENHA
                  CustomTextField(
                    controller: _senhaController,
                    hintText: 'Senha',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),

                  const SizedBox(height: 16),

                  /// CONFIRMAR SENHA
                  CustomTextField(
                    controller:
                        _confirmarSenhaController,
                    hintText: 'Confirmar Senha',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),

                  const SizedBox(height: 32),

                  /// BOTÃO CADASTRAR
                  CustomButton(
                    text: 'Cadastrar',
                    onPressed: _cadastrar,
                  ),

                  const SizedBox(height: 16),

                  /// LOGIN
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/login',
                      );
                    },

                    child: const Text(
                      'Já tem uma conta? Faça login',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}