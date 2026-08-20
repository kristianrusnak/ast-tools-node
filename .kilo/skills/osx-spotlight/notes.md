TARGET="$HOME"; [[ -z $(mdfind -onlyin "$TARGET" "kMDItemContentModificationDate > 0") ]] && echo "Excluded" || echo "Indexed"

mdfind -onlyin "$HOME" "kMDItemTextContent == 'API_KEY'" -0 | xargs -0 grep -o "API_KEY.*$"