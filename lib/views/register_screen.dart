import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../modele/utilisateur.dart';
import '../services/database_manager.dart';
import '../widgets/note_illustration.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color bleu = Color(0xFF2563EB);

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _confirmationController = TextEditingController();

  bool _motDePasseVisible = false;
  bool _confirmationVisible = false;

  Future<void> _sInscrire() async {
    final nom = _nomController.text.trim();
    final email = _emailController.text.trim();
    final motDePasse = _motDePasseController.text.trim();
    final confirmation = _confirmationController.text.trim();

    if (nom.isEmpty ||
        email.isEmpty ||
        motDePasse.isEmpty ||
        confirmation.isEmpty) {
      _afficherMessage('Veuillez remplir tous les champs.');
      return;
    }

    if (!email.contains('@')) {
      _afficherMessage('Veuillez saisir une adresse email valide.');
      return;
    }

    if (motDePasse != confirmation) {
      _afficherMessage('Les mots de passe ne correspondent pas.');
      return;
    }

    final utilisateur = Utilisateur.sansId(
      nomUtilisateur: nom,
      email: email,
      motDePasse: motDePasse,
    );

    try {
      await DatabaseManager.instance.registerUtilisateur(utilisateur);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compte créé avec succès.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } on DatabaseException {
      _afficherMessage('Ce nom d’utilisateur ou cet email existe déjà.');
    }
  }

  void _afficherMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _motDePasseController.dispose();
    _confirmationController.dispose();
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
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const NoteIllustration(size: 110),
              const SizedBox(height: 24),
              const Text(
                'Créer un compte',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Rejoignez MyNote App et sauvegardez vos idées.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nomController,
                decoration: _inputDecoration(
                  label: 'Nom d’utilisateur',
                  icon: Icons.person,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(label: 'Email', icon: Icons.email),
              ),
              const SizedBox(height: 14),
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
              const SizedBox(height: 14),
              TextField(
                controller: _confirmationController,
                obscureText: !_confirmationVisible,
                decoration: _inputDecoration(
                  label: 'Confirmer le mot de passe',
                  icon: Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmationVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmationVisible = !_confirmationVisible;
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
                  onPressed: _sInscrire,
                  child: const Text(
                    'S’inscrire',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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
