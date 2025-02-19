#!/bin/bash

# Variables
BASE_URL="https://pictioniary.wevox.cloud/api"
PLAYER_PASSWORD="Testtest24!"
GAME_SESSION_ID=$1

# Tableau pour stocker les tokens
declare -a TOKENS=()

join_player() {
    local team_color=$1
    local team_emoji="🔴"
    [[ "$team_color" == "blue" ]] && team_emoji="🔵"
    local max_retries=3
    local retry=0
    
    while [ $retry -lt $max_retries ]; do
        # Générer un nom aléatoire pour le joueur
        local random_suffix=$((RANDOM % 10000))
        local player_name="TestPlayer$random_suffix"

        echo "$team_emoji Création du joueur $player_name..." >&2
        local create_response=$(curl -s -X POST "$BASE_URL/players" \
          -H "Content-Type: application/json" \
          -d "{\"name\":\"$player_name\", \"password\":\"$PLAYER_PASSWORD\"}")

        local player_id=$(echo $create_response | jq -r '.id // empty')
        if [[ -z "$player_id" ]]; then
            echo "❌ Échec de la création du joueur (tentative $((retry + 1))/$max_retries)" >&2
            retry=$((retry + 1))
            sleep 1
            continue
        fi
        echo "✅ Joueur créé (ID: $player_id)" >&2

        echo "🔑 Connexion de $player_name..." >&2
        local login_response=$(curl -s -X POST "$BASE_URL/login" \
          -H "Content-Type: application/json" \
          -d "{\"name\":\"$player_name\", \"password\":\"$PLAYER_PASSWORD\"}")

        local token=$(echo $login_response | jq -r '.token // empty')
        if [[ -z "$token" ]]; then
            echo "❌ Échec de la connexion (tentative $((retry + 1))/$max_retries)" >&2
            retry=$((retry + 1))
            sleep 1
            continue
        fi

        TOKENS+=("$token")
        echo "✅ Connexion réussie" >&2

        echo "➕ Ajout à la session $GAME_SESSION_ID..." >&2
        local join_response=$(curl -s -X POST "$BASE_URL/game_sessions/$GAME_SESSION_ID/join" \
          -H "Authorization: Bearer $token" \
          -H "Content-Type: application/json" \
          -d "{\"color\":\"$team_color\"}")

        local join_player_id=$(echo $join_response | jq -r '.player_id // empty')
        if [[ -z "$join_player_id" ]]; then
            local autre_team="blue"
            local autre_emoji="🔵"
            [[ "$team_color" == "blue" ]] && autre_team="red" && autre_emoji="🔴"
            
            echo "ℹ️  Équipe $team_color pleine, tentative équipe $autre_team..." >&2
            join_response=$(curl -s -X POST "$BASE_URL/game_sessions/$GAME_SESSION_ID/join" \
              -H "Authorization: Bearer $token" \
              -H "Content-Type: application/json" \
              -d "{\"color\":\"$autre_team\"}")
            
            join_player_id=$(echo $join_response | jq -r '.player_id // empty')
            if [[ -z "$join_player_id" ]]; then
                echo "❌ Impossible de rejoindre la session (tentative $((retry + 1))/$max_retries)" >&2
                retry=$((retry + 1))
                sleep 1
                continue
            fi
        fi
        echo "✅ Joueur ajouté à la session" >&2
        return 0
    done

    echo "❌ Échec après $max_retries tentatives" >&2
    return 1
}

if [ -z "$GAME_SESSION_ID" ]; then
    echo "❌ Erreur: ID de session requis" >&2
    echo "ℹ️  Usage: ./join_session.sh <game_session_id>" >&2
    exit 1
fi

echo "🎮 Configuration de la session #$GAME_SESSION_ID..." >&2

echo "👥 Ajout des joueurs..." >&2
join_player "red"
join_player "blue"
join_player "red"

echo "✨ Configuration terminée" >&2
echo "[\"${TOKENS[0]}\",\"${TOKENS[1]}\",\"${TOKENS[2]}\"]"

