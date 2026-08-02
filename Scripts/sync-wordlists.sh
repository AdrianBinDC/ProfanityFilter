#!/usr/bin/env bash
# Fetch plaintext lists from coffee-and-fun/google-profanity-words and hash them.
# Usage: Scripts/sync-wordlists.sh <git-ref>
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REF="${1:?Usage: $0 <git-ref>}"
OUT_DIR="$ROOT/Sources/ProfanityFilter/Resources/WordLists"
LANGS=(en es fr ga ar zh)
BASE_URL="https://raw.githubusercontent.com/coffee-and-fun/google-profanity-words/${REF}/data"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$OUT_DIR"

for code in "${LANGS[@]}"; do
  src="$TMP/${code}.txt"
  dest="$OUT_DIR/${code}.hashes"
  url="${BASE_URL}/${code}.txt"
  echo "Fetching ${url}"
  curl -fsSL "$url" -o "$src"
  swift "$ROOT/Scripts/hash-wordlist.swift" "$src" "$dest"
done

echo "Synced word lists from coffee-and-fun/google-profanity-words@${REF}"
