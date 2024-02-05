# dbz_app

Projet R4.11 BUT2 Informatique de création d'une application mobile sur le thème "Dragon Ball Z".

Il s'agit d'une application Dart utilisant une base de données SQLite pour stocker des informations sur les films. Elle affiche des détails sur les personnages de Dragon Ball Z et offre des fonctionnalités de création et de connexion à un compte utilisateur. Les informations sur les films sont récupérées depuis une API et stockées localement.

## Caractéristiques

- Connexion utilisateur avec option de sauvegarde des identifiants
- Liste des personnages de DBZ
- Récupération des informations des personnages depuis une API externe ("superheorapi.com") et un fichier JSON local
- Affichage détaillé des personnages en mode grille
- Stockage d'une liste de films dans une base de données SQLite
- Récupération des informations des films depuis la base de données et l'API "anime-db.p.rapidapi.com"

## Technologies utilisées

- Dart
- Flutter
- Package HTTP pour les requêtes API
- Package sqflite pour la gestion de la base de données SQLite
- Package path_provider pour trouver le chemin du répertoire de l'application
- SharedPreferences pour la gestion des sessions utilisateur

## Comment exécuter le projet

1. Assurez-vous d'avoir Flutter et Dart installés sur votre machine.
2. Clonez ce dépôt.
3. Exécutez `flutter pub get` pour installer les dépendances.
4. Exécutez `flutter run` pour démarrer l'application.

## Auteur

AllanGoku
