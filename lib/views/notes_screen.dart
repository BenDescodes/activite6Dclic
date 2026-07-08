import 'package:flutter/material.dart';

import '../modele/note.dart';
import '../services/database_manager.dart';
import '../widgets/note_illustration.dart';
import 'login_screen.dart';
import 'modifier_note_screen.dart';

class NotesScreen extends StatefulWidget {
  final int utilisateurId;
  final String nomUtilisateur;

  const NotesScreen({
    super.key,
    required this.utilisateurId,
    required this.nomUtilisateur,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  static const Color bleu = Color(0xFF2563EB);

  final TextEditingController _noteController = TextEditingController();

  List<Note> _notes = [];
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _chargerNotes();
  }

  Future<void> _chargerNotes() async {
    final notes = await DatabaseManager.instance.getAllNotes(
      widget.utilisateurId,
    );

    setState(() {
      _notes = notes;
      _chargement = false;
    });
  }

  Future<void> _ajouterNote() async {
    final contenu = _noteController.text.trim();

    if (contenu.isEmpty) {
      _afficherMessage('Veuillez saisir une note avant d’ajouter.', Colors.red);
      return;
    }

    final note = Note.sansId(
      utilisateurId: widget.utilisateurId,
      contenu: contenu,
    );

    await DatabaseManager.instance.insertNote(note);

    _noteController.clear();

    await _chargerNotes();

    _afficherMessage('Note ajoutée avec succès.', Colors.green);
  }

  Future<void> _changerStatut(Note note) async {
    final noteModifiee = note.copyWith(
      realise: !note.realise,
      dateModification: DateTime.now().toIso8601String(),
    );

    await DatabaseManager.instance.updateNote(noteModifiee);

    await _chargerNotes();
  }

  Future<void> _supprimerNote(Note note) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer la note ?'),
          content: const Text('Voulez-vous vraiment supprimer cette note ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmation != true) return;

    await DatabaseManager.instance.deleteNote(note.id!);

    await _chargerNotes();

    _afficherMessage('Note supprimée avec succès.', Colors.green);
  }

  Future<void> _ouvrirModification(Note note) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => ModifierNoteScreen(note: note)),
    );

    if (result == true) {
      await _chargerNotes();
    }
  }

  void _seDeconnecter() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _afficherMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Liste des notes'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF0F172A),
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: 'Ajouter une note',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 54,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bleu,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _ajouterNote,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _chargement
                  ? const Center(child: CircularProgressIndicator())
                  : _notes.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 88),
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        final note = _notes[index];
                        return _buildNoteCard(note);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFDC2626),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.logout),
        label: const Text('Se déconnecter'),
        onPressed: _seDeconnecter,
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NoteIllustration(size: 120),
          SizedBox(height: 24),
          Text(
            'Aucune note trouvée',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ajoutez votre première note pour commencer.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              note.realise ? Icons.check_circle : Icons.radio_button_unchecked,
              color: note.realise ? Colors.green : const Color(0xFF94A3B8),
            ),
            onPressed: () {
              _changerStatut(note);
            },
          ),
          Expanded(
            child: Text(
              note.contenu,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
                decoration: note.realise ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () {
              _ouvrirModification(note);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: () {
              _supprimerNote(note);
            },
          ),
        ],
      ),
    );
  }
}
