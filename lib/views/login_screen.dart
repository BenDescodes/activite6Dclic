import 'package:flutter/material.dart';

import '../services/database_manager.dart';
import '../widgets/note_illustration.dart';
import 'notes_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color bleu = Color(0xFF2563EB);

  final TextEditingController _identifiantController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();

  bool _chargement = false;
  bool _motDePasseVisible = false;

  Future<void> _seConnecter() async {
    final identifiant = _identifiantController.text.trim();
    final motDePasse = _motDePasseController.text.trim();

    if (identifiant.isEmpty || motDePasse.isEmpty) {
      _afficherMessage('Veuillez remplir tous les champs.');
      return;
    }

    setState(() {
      _chargement = true;
    });

    final utilisateur = await DatabaseManager.instance.loginUtilisateur(
      identifiant: identifiant,
      motDePasse: motDePasse,
    );

    setState(() {
      _chargement = false;
    });

    if (utilisateur == null) {
      _afficherMessage('Nom d’utilisateur ou mot de passe incorrect.');
      return;
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NotesScreen(
          utilisateurId: utilisateur.id!,
          nomUtilisateur: utilisateur.nomUtilisateur,
        ),
      ),
    );
  }

  void _afficherMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _identifiantController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'Se connecter',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Bienvenue sur MyNote App',
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),
              const NoteIllustration(size: 120),
              const SizedBox(height: 40),
              TextField(
                controller: _identifiantController,
                decoration: _inputDecoration(
                  label: 'Nom d’utilisateur ou email',
                  icon: Icons.person,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _motDePasseController,
                obscureText: !_motDePasseVisible,
                decoration: _inputDecoration(
                  label: 'Mot de passe',
                  icon: Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _motDePasseVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _motDePasseVisible = !_motDePasseVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bleu,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _chargement ? null : _seConnecter,
                  child: _chargement
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Se connecter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 22),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Créer un compte',
                  style: TextStyle(color: bleu, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
    );
  }
}
