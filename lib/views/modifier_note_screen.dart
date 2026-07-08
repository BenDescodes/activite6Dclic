import 'package:flutter/material.dart';

import '../modele/note.dart';
import '../services/database_manager.dart';

class ModifierNoteScreen extends StatefulWidget {
  final Note note;

  const ModifierNoteScreen({super.key, required this.note});

  @override
  State<ModifierNoteScreen> createState() => _ModifierNoteScreenState();
}

class _ModifierNoteScreenState extends State<ModifierNoteScreen> {
  static const Color bleu = Color(0xFF2563EB);

  late TextEditingController _contenuController;
  late String _realiser;

  @override
  void initState() {
    super.initState();
    _contenuController = TextEditingController(text: widget.note.contenu);
    _realiser = widget.note.realise ? 'Oui' : 'Non';
  }

  Future<void> _modifierNote() async {
    final contenu = _contenuController.text.trim();

    if (contenu.isEmpty) {
      _afficherMessage('La note ne peut pas être vide.', Colors.red);
      return;
    }

    final noteModifiee = widget.note.copyWith(
      contenu: contenu,
      realise: _realiser == 'Oui',
      dateModification: DateTime.now().toIso8601String(),
    );

    await DatabaseManager.instance.updateNote(noteModifiee);

    if (!mounted) return;

    _afficherMessage('Note modifiée avec succès.', Colors.green);

    Navigator.pop(context, true);
  }

  Future<void> _supprimerNote() async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer la note ?'),
          content: const Text(
            'Cette action est irréversible. Voulez-vous vraiment supprimer cette note ?',
          ),
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

    await DatabaseManager.instance.deleteNote(widget.note.id!);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  void _afficherMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  void dispose() {
    _contenuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Modifier une note'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contenuController,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: 'Contenu de la note',
                filled: true,
                fillColor: Colors.white,
                alignLabelWithHint: true,
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
            const SizedBox(height: 24),
            const Text(
              'Réaliser',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _realiser,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Oui', child: Text('Oui')),
                DropdownMenuItem(value: 'Non', child: Text('Non')),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _realiser = value;
                });
              },
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bleu,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _modifierNote,
                    child: const Text('Modifier'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            Center(
              child: TextButton.icon(
                onPressed: _supprimerNote,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  'Supprimer la note',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
