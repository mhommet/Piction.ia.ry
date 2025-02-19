#!/bin/bash

# Variables
BASE_URL="https://pictioniary.wevox.cloud/api"
PLAYER_PASSWORD="Testtest24!"
GAME_SESSION_ID=$1

# Liste de challenges prédéfinis avec des mots interdits différents
declare -a CHALLENGES=(
    "['volaille', 'brique', 'poulet']"
    "['animal', 'ferme', 'oeuf']"
    "['volatile', 'piaf', 'aile']"
    "['maison', 'pierre', 'construction']"
    "['hauteur', 'grimper', 'escalade']"
    "['barrière', 'clôture', 'enclos']"
    "['jardin', 'potager', 'extérieur']"
    "['campagne', 'rural', 'nature']"
    "['équilibre', 'perché', 'stable']"
    "['chant', 'caqueter', 'bruit']"
    "['plume', 'bec', 'patte']"
    "['nid', 'coq', 'poussins']"
)

join_player() {
    local team_color=$1
    
    # Générer un nom aléatoire pour le joueur
    local random_suffix=$((RANDOM % 10000))
    local player_name="TestPlayer$random_suffix"

    echo "Création du joueur $player_name..."
    local create_response=$(curl -s -X POST "$BASE_URL/players" \
      -H "Content-Type: application/json" \
      -d "{\"name\":\"$player_name\", \"password\":\"$PLAYER_PASSWORD\"}")

    echo "Réponse à la création : $create_response"

    local player_id=$(echo $create_response | jq -r '.id // empty')
    if [[ -z "$player_id" ]]; then
      echo "Erreur lors de la création du joueur. Réponse détaillée : $create_response"
      return 1
    else
      echo "Joueur créé avec succès : ID = $player_id"
    fi

    # Connexion du joueur
    echo "Connexion du joueur $player_name..."
    local login_response=$(curl -s -X POST "$BASE_URL/login" \
      -H "Content-Type: application/json" \
      -d "{\"name\":\"$player_name\", \"password\":\"$PLAYER_PASSWORD\"}")

    echo "Réponse à la connexion : $login_response"

    local token=$(echo $login_response | jq -r '.token // empty')
    if [[ -z "$token" ]]; then
      echo "Erreur lors de la connexion. Réponse : $login_response"
      return 1
    fi

    echo "Connexion réussie. Token récupéré : $token"

    # Rejoindre une session de jeu
    echo "Ajout du joueur $player_name à la session $GAME_SESSION_ID..."
    local join_response=$(curl -s -X POST "$BASE_URL/game_sessions/$GAME_SESSION_ID/join" \
      -H "Authorization: Bearer $token" \
      -H "Content-Type: application/json" \
      -d "{\"color\":\"$team_color\"}")

    echo "Réponse à l'ajout : $join_response"

    local join_player_id=$(echo $join_response | jq -r '.player_id // empty')
    if [[ -z "$join_player_id" ]]; then
      local autre_team="blue"
      [[ "$team_color" == "blue" ]] && autre_team="red"
      echo "L'équipe $team_color est pleine, tentative de rejoindre l'équipe $autre_team..."
      join_response=$(curl -s -X POST "$BASE_URL/game_sessions/$GAME_SESSION_ID/join" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d "{\"color\":\"$autre_team\"}")
      echo "Réponse à l'ajout : $join_response"
      join_player_id=$(echo $join_response | jq -r '.player_id // empty')
      if [[ -z "$join_player_id" ]]; then
        echo "Erreur lors de l'ajout à la session. Réponse détaillée : $join_response"
        return 1
      fi
    fi
    echo "Joueur ajouté avec succès à la session. Détails de la session : $join_response"
}

add_challenges() {
    local token=$1
    echo "Ajout de 12 challenges à la session $GAME_SESSION_ID..."

    for forbidden in "${CHALLENGES[@]}"; do
        echo "Ajout d'un nouveau challenge..."
        local challenge_response=$(curl -s -X POST "$BASE_URL/game_sessions/$GAME_SESSION_ID/challenges" \
          -H "Authorization: Bearer $token" \
          -H "Content-Type: application/json" \
          -d "{
              \"first_word\": \"une\",
              \"second_word\": \"poule\",
              \"third_word\": \"sur\",
              \"fourth_word\": \"un\",
              \"fifth_word\": \"mur\",
              \"forbidden_words\": $forbidden
          }")
        
        echo "Réponse : $challenge_response"
        sleep 1
    done
    echo "Ajout des challenges terminé."
}

if [ -z "$GAME_SESSION_ID" ]; then
    echo "Erreur: Veuillez fournir l'ID de la session de jeu"
    echo "Usage: ./join_session.sh <game_session_id>"
    exit 1
fi

# Ajouter les joueurs
echo "Ajout du premier joueur (équipe rouge)..."
FIRST_PLAYER_NAME=""
FIRST_PLAYER_TOKEN=""

# Créer et connecter le premier joueur
RANDOM_SUFFIX=$((RANDOM % 10000))
FIRST_PLAYER_NAME="TestPlayer$RANDOM_SUFFIX"

CREATE_RESPONSE=$(curl -s -X POST "$BASE_URL/players" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$FIRST_PLAYER_NAME\", \"password\":\"$PLAYER_PASSWORD\"}")

PLAYER_ID=$(echo $CREATE_RESPONSE | jq -r '.id // empty')
if [[ -z "$PLAYER_ID" ]]; then
    echo "Erreur lors de la création du premier joueur"
    exit 1
fi

LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$FIRST_PLAYER_NAME\", \"password\":\"$PLAYER_PASSWORD\"}")

FIRST_PLAYER_TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.token // empty')
if [[ -z "$FIRST_PLAYER_TOKEN" ]]; then
    echo "Erreur lors de la connexion du premier joueur"
    exit 1
fi

# Ajouter le premier joueur à l'équipe rouge
join_player "red"

echo "Ajout du deuxième joueur (équipe bleue)..."
join_player "blue"

echo "Ajout du troisième joueur (équipe rouge)..."
join_player "red"

# Ajouter les challenges en utilisant le token du premier joueur
echo "Ajout des challenges avec le joueur $FIRST_PLAYER_NAME..."
add_challenges "$FIRST_PLAYER_TOKEN"

echo "Script terminé avec succès."

