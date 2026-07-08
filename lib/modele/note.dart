class Note {
  final int? id;
  final int utilisateurId;
  final String contenu;
  final bool realise;
  final String dateCreation;
  final String dateModification;

  Note({
    required this.id,
    required this.utilisateurId,
    required this.contenu,
    required this.realise,
    required this.dateCreation,
    required this.dateModification,
  });

  Note.sansId({
    required this.utilisateurId,
    required this.contenu,
    this.realise = false,
  }) : id = null,
       dateCreation = DateTime.now().toIso8601String(),
       dateModification = DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'utilisateurId': utilisateurId,
      'contenu': contenu,
      'realise': realise ? 1 : 0,
      'dateCreation': dateCreation,
      'dateModification': dateModification,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int,
      utilisateurId: map['utilisateurId'] as int,
      contenu: map['contenu'] as String,
      realise: map['realise'] == 1,
      dateCreation: map['dateCreation'] as String,
      dateModification: map['dateModification'] as String,
    );
  }

  Note copyWith({
    int? id,
    int? utilisateurId,
    String? contenu,
    bool? realise,
    String? dateCreation,
    String? dateModification,
  }) {
    return Note(
      id: id ?? this.id,
      utilisateurId: utilisateurId ?? this.utilisateurId,
      contenu: contenu ?? this.contenu,
      realise: realise ?? this.realise,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? this.dateModification,
    );
  }
}
