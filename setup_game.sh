#!/bin/bash

# Variables
BASE_URL="https://pictioniary.wevox.cloud/api"
GAME_SESSION_ID=$1

if [ -z "$GAME_SESSION_ID" ]; then
    echo "❌ Erreur: Veuillez fournir l'ID de la session de jeu"
    echo "ℹ️  Usage: ./setup_game.sh <game_session_id>"
    exit 1
fi

# D'abord se connecter avec milan444 pour vérifier la session
echo "🔑 Connexion initiale..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"milan444\", \"password\":\"444\"}")

INITIAL_TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.token // empty')
if [[ -z "$INITIAL_TOKEN" ]]; then
    echo "❌ Échec de la connexion initiale"
    exit 1
fi

# Vérifier l'état de la session
echo "🔍 Vérification de la session #$GAME_SESSION_ID..."
SESSION_RESPONSE=$(curl -s -X GET "$BASE_URL/game_sessions/$GAME_SESSION_ID" \
  -H "Authorization: Bearer $INITIAL_TOKEN")
SESSION_STATUS=$(echo $SESSION_RESPONSE | jq -r '.status // empty')

if [ -z "$SESSION_STATUS" ]; then
    echo "❌ Session introuvable"
    echo "🔍 Réponse: $SESSION_RESPONSE"
    exit 1
fi

# Vérifier le nombre de joueurs
RED_TEAM=$(echo $SESSION_RESPONSE | jq -r '.red_team | length')
BLUE_TEAM=$(echo $SESSION_RESPONSE | jq -r '.blue_team | length')

echo "👥 Équipe rouge: $RED_TEAM joueurs"
echo "👥 Équipe bleue: $BLUE_TEAM joueurs"

if [ "$RED_TEAM" -eq 2 ] && [ "$BLUE_TEAM" -eq 2 ]; then
    echo "❌ La session est déjà pleine"
    exit 1
fi

# 1. Ajouter les joueurs à la session et récupérer les tokens
echo "➕ Ajout des joueurs à la session..."
TOKENS_JSON=$(./join_session.sh $GAME_SESSION_ID | tail -n 1)
readarray -t TOKENS < <(echo $TOKENS_JSON | jq -r '.[]')

# Vérifier que nous avons bien les tokens
if [ ${#TOKENS[@]} -ne 3 ]; then
    echo "❌ Impossible de récupérer les tokens des joueurs"
    echo "🔍 Tokens reçus: $TOKENS_JSON"
    exit 1
fi

PLAYER2_TOKEN="${TOKENS[0]}"
PLAYER3_TOKEN="${TOKENS[1]}"
PLAYER4_TOKEN="${TOKENS[2]}"

# 2. Attendre que la partie se lance et passe en mode challenge
echo "⏳ Attente du lancement automatique (15s)..."
sleep 15

echo "⏳ Attente du passage en mode challenge (10s)..."
sleep 10

# 3. Ajouter les défis pour chaque joueur
echo "🎲 Ajout des défis..."

# Liste de challenges pour chaque joueur
declare -a CHALLENGES_PLAYER2=(
    '["courir", "marcher", "sauter"]'
    '["rapide", "vitesse", "sprint"]'
    '["jambe", "pied", "chaussure"]'
)

declare -a CHALLENGES_PLAYER3=(
    '["manger", "cuisine", "repas"]'
    '["assiette", "fourchette", "couteau"]'
    '["faim", "nourriture", "restaurant"]'
)

declare -a CHALLENGES_PLAYER4=(
    '["dormir", "lit", "nuit"]'
    '["rêve", "oreiller", "couverture"]'
    '["fatigue", "sommeil", "repos"]'
)

# Fonction pour ajouter les défis d'un joueur
add_player_challenges() {
    local token=$1
    local challenges=("${@:2}")
    local added=0
    
    echo "👤 Ajout des défis pour un joueur..."
    
    for forbidden in "${challenges[@]}"; do
        if [ $added -ge 3 ]; then
            break
        fi
        
        echo "   📝 Défi $((added + 1))/3..."
        curl -s -X POST "$BASE_URL/game_sessions/$GAME_SESSION_ID/challenges" \
          -H "Authorization: Bearer $token" \
          -H "Content-Type: application/json" \
          -d "{
              \"first_word\": \"une\",
              \"second_word\": \"poule\",
              \"third_word\": \"sur\",
              \"fourth_word\": \"un\",
              \"fifth_word\": \"mur\",
              \"forbidden_words\": $forbidden
          }" > /dev/null
        
        added=$((added + 1))
        sleep 1
    done
    echo "   ✅ Défis ajoutés"
}

# Ajouter les défis avec les tokens respectifs de chaque joueur
echo "👤 Joueur 2..."
add_player_challenges "$PLAYER2_TOKEN" "${CHALLENGES_PLAYER2[@]}"

echo "👤 Joueur 3..."
add_player_challenges "$PLAYER3_TOKEN" "${CHALLENGES_PLAYER3[@]}"

echo "👤 Joueur 4..."
add_player_challenges "$PLAYER4_TOKEN" "${CHALLENGES_PLAYER4[@]}"

echo "🎉 Configuration de la partie terminée avec succès !" 