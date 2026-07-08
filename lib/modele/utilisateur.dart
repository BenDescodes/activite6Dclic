class Utilisateur {
  final int? id;
  final String nomUtilisateur;
  final String email;
  final String motDePasse;

  Utilisateur({
    required this.id,
    required this.nomUtilisateur,
    required this.email,
    required this.motDePasse,
  });

  Utilisateur.sansId({
    required this.nomUtilisateur,
    required this.email,
    required this.motDePasse,
  }) : id = null;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nomUtilisateur': nomUtilisateur,
      'email': email,
      'motDePasse': motDePasse,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'] as int,
      nomUtilisateur: map['nomUtilisateur'] as String,
      email: map['email'] as String,
      motDePasse: map['motDePasse'] as String,
    );
  }
}
