API URL : https://pictioniary.wevox.cloud/api

POST /players: Création d'un joueur avec un mot de passe
Args: {name, password}

POST /login: Identification sur l'API
Args: {name, password}
Return: JWT

-- Toutes les routes suivantes sont protégées par vérification du JWT en Bearer

GET /players/{id}: Détail d'un joueur

POST /game_sessions: Création d'une session de jeu
Return: l'id de la session de jeu

GET /game_sessions/{id} - Détails d'une session de jeu
Return: Objet GameSession

POST /game_sessions/{id}/join - Rejoinde une session de jeu
Agrs: {color: [red, blue]} - L'argument correspond à l'équipe à rejoindre
Return: Objet GameSession

GET /game_sessions/{id}/leave - Quitter une session de jeu
Return: Objet GameSession