# Maintainer word lists

Plaintext corpora live here locally and are **gitignored**. The package ships only salted digests under `Sources/ProfanityFilter/Resources/WordLists/`.

## Update the English list

1. Edit `Maintainer/en.txt` (one word or phrase per line; `#` comments allowed).
2. Regenerate digests:

   ```bash
   make hash-wordlist
   ```

3. Commit **only** `Sources/ProfanityFilter/Resources/WordLists/en.hashes` (never the `.txt`).

## Probe membership

Check whether a word hashes into the committed set without printing the corpus:

```bash
make check-word WORD=example
```

## Show local plaintext

```bash
make reveal-wordlist
```

Fails if `Maintainer/en.txt` is missing (expected on a fresh clone).

## Add another language later

1. Add `Maintainer/<code>.txt` and wire `make hash-wordlist` (or a dedicated target) to emit `Sources/ProfanityFilter/Resources/WordLists/<code>.hashes`.
2. Add a `Language` case whose `rawValue` matches the file stem (e.g. `es` → `es.hashes`).
3. Extend `Language` ↔ `NLLanguage` mapping in `LanguageDetector` when automatic detection should pick it up.
