#!/bin/bash

# Variables
BASE_URL="https://pictioniary.wevox.cloud/api"
GAME_SESSION_ID=$1
PLAYER_NAME="milan444"
PLAYER_PASSWORD="444"

# Liste de challenges prédéfinis avec des mots interdits différents
declare -a CHALLENGES=(
    '["volaille", "brique", "poulet"]'
    '["animal", "ferme", "oeuf"]'
    '["volatile", "piaf", "aile"]'
)

if [ -z "$GAME_SESSION_ID" ]; then
    echo "Erreur: Veuillez fournir l'ID de la session de jeu"
    echo "Usage: ./add_challenges.sh <game_session_id>"
    exit 1
fi

# Connexion du joueur
echo "Connexion de $PLAYER_NAME..." >&2
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$PLAYER_NAME\", \"password\":\"$PLAYER_PASSWORD\"}")

TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.token // empty')
if [[ -z "$TOKEN" ]]; then
    echo "Erreur lors de la connexion" >&2
    exit 1
fi

# Attendre que la session soit en mode "challenge"
echo "Attente que la session passe en mode challenge..."
while true; do
    STATUS_RESPONSE=$(curl -s -X GET "$BASE_URL/game_sessions/$GAME_SESSION_ID" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json")
    
    STATUS=$(echo $STATUS_RESPONSE | jq -r '.status // empty')
    echo "Statut actuel : $STATUS"
    
    if [ "$STATUS" = "challenge" ]; then
        break
    fi
    sleep 2
done

# Ajouter les challenges
echo "Ajout de 3 challenges à la session $GAME_SESSION_ID..." >&2

for forbidden in "${CHALLENGES[@]}"; do
    echo "Ajout d'un nouveau challenge..." >&2
    CHALLENGE_RESPONSE=$(curl -s -X POST "$BASE_URL/game_sessions/$GAME_SESSION_ID/challenges" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{
          \"first_word\": \"une\",
          \"second_word\": \"poule\",
          \"third_word\": \"sur\",
          \"fourth_word\": \"un\",
          \"fifth_word\": \"mur\",
          \"forbidden_words\": $forbidden
      }")
    
    echo "Réponse : $CHALLENGE_RESPONSE" >&2
    sleep 1
done

echo "Ajout des challenges terminé avec succès." >&2
echo "$TOKEN"  # Retourner le token pour setup_game.sh 