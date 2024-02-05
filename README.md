# dbz_app

Mon projet R4.11 de création d'une application mobile. Dont le thème que j'ai choisi est "Dragon Ball Z".

C'est une application Dart qui utilise une base de données SQLite pour stocker pour stocker des informations sur les films, qui affiche des informations sur les personnages de Dragon Ball Z et qui permet de se créer ou bien de se connecter à un compte. Les films sont récupérés à partir d'une API puis stocké sur une base de données locale.

## Caractéristiques

- Connexion utilisateur avec option pour rester connecté
- Affiche une liste de personnages de DBZ
- Récupère les informations des personnages à partir d'une API externe ("superheorapi.com") et d'un fichier JSON local
- Affiche les détails des personnages dans une vue de grille
- Stocke une liste de films dans une base de données SQLite
- Récupère les informations des films à partir de la base de données
- Récupère les informations des films à partir de l'API "anime-db.p.rapidapi.com"

## Technologies utilisées

- Dart
- Flutter
- http package pour les requêtes API
- sqflite package pour la gestion de la base de données SQLite
- path_provider package pour trouver le chemin du répertoire de l'application
- SharedPreferences pour la gestion des sessions utilisateur

## Comment exécuter le projet

1. Assurez-vous d'avoir installé Flutter et Dart sur votre machine.
2. Clonez ce dépôt.
3. Exécutez `flutter pub get` pour installer les dépendances.
4. Exécutez `flutter run` pour démarrer l'application.

## Auteur

AllanGoku
