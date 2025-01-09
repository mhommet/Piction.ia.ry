#!/bin/bash

# Variables
BASE_URL="https://pictioniary.wevox.cloud/api"
PLAYER_PASSWORD="Testtest24!"
GAME_SESSION_ID=$1
TEAM_COLOR="red"  # 'red' ou 'blue'

# Générer un nom aléatoire pour le joueur
RANDOM_SUFFIX=$((RANDOM % 10000))
PLAYER_NAME="TestPlayer$RANDOM_SUFFIX"

# Ajouter un joueur
echo "Création du joueur $PLAYER_NAME..."
CREATE_RESPONSE=$(curl -s -X POST "$BASE_URL/players" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$PLAYER_NAME\", \"password\":\"$PLAYER_PASSWORD\"}")

echo "Réponse à la création : $CREATE_RESPONSE"

PLAYER_ID=$(echo $CREATE_RESPONSE | jq -r '.id // empty')
if [[ -z "$PLAYER_ID" ]]; then
  echo "Erreur lors de la création du joueur. Réponse détaillée : $CREATE_RESPONSE"
  exit 1
else
  echo "Joueur créé avec succès : ID = $PLAYER_ID"
fi

# Connexion du joueur
echo "Connexion du joueur $PLAYER_NAME..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$PLAYER_NAME\", \"password\":\"$PLAYER_PASSWORD\"}")

echo "Réponse à la connexion : $LOGIN_RESPONSE"

TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.token // empty')
if [[ -z "$TOKEN" ]]; then
  echo "Erreur lors de la connexion. Réponse : $LOGIN_RESPONSE"
  exit 1
fi

echo "Connexion réussie. Token récupéré : $TOKEN"

# Rejoindre une session de jeu
echo "Ajout du joueur $PLAYER_NAME à la session $GAME_SESSION_ID..."
JOIN_RESPONSE=$(curl -s -X POST "$BASE_URL/game_sessions/$GAME_SESSION_ID/join" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"color\":\"$TEAM_COLOR\"}")

echo "Réponse à l'ajout : $JOIN_RESPONSE"

JOIN_PLAYER_ID=$(echo $JOIN_RESPONSE | jq -r '.player_id // empty')
if [[ -z "$JOIN_PLAYER_ID" ]]; then
  echo "L'équipe rouge est pleine, tentative de rejoindre l'équipe bleue..."
  TEAM_COLOR="blue"
  JOIN_RESPONSE=$(curl -s -X POST "$BASE_URL/game_sessions/$GAME_SESSION_ID/join" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"color\":\"$TEAM_COLOR\"}")
  echo "Réponse à l'ajout : $JOIN_RESPONSE"
  JOIN_PLAYER_ID=$(echo $JOIN_RESPONSE | jq -r '.player_id // empty')
  if [[ -z "$JOIN_PLAYER_ID" ]]; then
    echo "Erreur lors de l'ajout à la session. Réponse détaillée : $JOIN_RESPONSE"
    exit 1
  else
    echo "Joueur ajouté avec succès à la session. Détails de la session : $JOIN_RESPONSE"
  fi
else
  echo "Joueur ajouté avec succès à la session. Détails de la session : $JOIN_RESPONSE"
fi

echo "Script terminé avec succès."

