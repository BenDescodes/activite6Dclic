## MyNote App

MyNote App est une application mobile de gestion de notes développée avec Flutter.

Elle permet à un utilisateur de créer un compte, de se connecter, d’ajouter des notes, de les afficher, de les modifier, de les marquer comme réalisées et de les supprimer.

## Technologies utilisées

- Flutter
- Dart
- SQLite
- Sqflite
- Path

## Installation du projet

1. Cloner ou télécharger le projet.

https://github.com/BenDescodes/activite6Dclic

2. Ouvrir le dossier du projet :

cd mynote_app

3. Installer les dépendances :

flutter pub get

4. Lancer l’application

flutter run

## Utilisation de l’application

- Ouvrir l’application.
- Cliquer sur le bouton Commencer.
- Créer un compte avec un nom d’utilisateur, un email et un mot de passe.
- Se connecter avec le nom d’utilisateur ou l’email.
- Ajouter une note dans le champ prévu.
- Modifier une note en cliquant sur l’icône de modification.
- Supprimer une note avec l’icône de suppression.
- Marquer une note comme réalisée avec l’icône de validation.

## Base de données

L’application utilise une base de données locale SQLite appelée : mynote_app.db

Elle contient deux tables principales :

- utilisateurs
- notes
  Chaque note possède un identifiant unique auto-incrémenté.

Table utilisateurs (id,nomUtilisateur,email,motDePasse)

Table notes (id,utilisateurId,contenu,realise,dateCreation,dateModification)

## Structure de l’application

Le projet est organisé en plusieurs dossiers :

- modele/

Ce dossier contient les classes représentant les données de l’application.
utilisateur.dart : représente un utilisateur.
note.dart : représente une note.

- services/

Ce dossier contient la logique liée à la base de données.
database_manager.dart : gère la création de la base SQLite et les opérations CRUD.

- views/

Ce dossier contient les interfaces de l’application.
start_screen.dart : écran d’accueil.
login_screen.dart : écran de connexion.
register_screen.dart : écran d’inscription.
notes_screen.dart : écran principal avec la liste des notes.
modifier_note_screen.dart : écran de modification d’une note.

- widgets/

Ce dossier contient les composants réutilisables.

note_illustration.dart : illustration utilisée dans les écrans d’accueil, de connexion et d’inscription.

## Choix de conception

L’application utilise une interface simple, claire et moderne.

Les choix principaux sont :

une couleur principale bleue ;
des boutons visibles ;
des champs de formulaire bien espacés ;
des cartes pour afficher les notes ;
des messages d’erreur explicites ;
une navigation simple entre les écrans.

## Sécurité

Dans cette version pédagogique, les mots de passe sont stockés localement dans SQLite afin de comprendre le fonctionnement d’une authentification simple.

Dans une application réelle, les mots de passe devraient être hachés ou gérés par un service d’authentification sécurisé.

## Wireframing

Le dossier asset/wireframing/ contient la conception visuelle des interfaces principales de l’application.

## Conclusion

MyNote App répond aux objectifs du projet en proposant une application fonctionnelle de gestion de notes avec Flutter et SQLite.

Elle met en pratique la création d’interfaces mobiles, la navigation entre écrans, la gestion d’une base de données locale et les opérations CRUD.
