# Piction IA ry

Une application Flutter de jeu de dessin collaboratif utilisant l'IA pour générer des images.

## Description

Piction IA ry est un jeu où les joueurs doivent :
1. Créer des défis composés de 5 mots et 3 mots interdits
2. Générer des images à partir de descriptions textuelles (sans utiliser les mots interdits)
3. Deviner les défis des autres joueurs à partir des images générées

## Installation

1. Cloner le repository
2. Installer Flutter
3. Exécuter `flutter pub get`
4. Lancer l'application avec `flutter run`

## Configuration rapide d'une partie test

Un script bash est disponible pour configurer rapidement une partie avec des joueurs et défis de test.

### Utilisation du script

```bash
./setup_game.sh <game_session_id>
```

Le script va :
- Ajouter 3 joueurs à la session
- Créer 3 défis pour chaque joueur
- Configurer automatiquement la partie

Lancer le script dans la page des équipes puis attendre que le script dise "Configuration de la partie terminée avec succès" et ensuite ajouter les trois défis dans l'app à la main.
