# Maintainer word lists

Canonical corpora come from [coffee-and-fun/google-profanity-words](https://github.com/coffee-and-fun/google-profanity-words) (MIT). This package commits **only** salted digests under `Sources/ProfanityFilter/Resources/WordLists/`.

## Update from upstream (the button)

1. Optionally bump `UPSTREAM_REF` in the root `Makefile` (or let the daily sync workflow open a PR).
2. Regenerate digests:

   ```bash
   make sync-wordlists
   ```

3. Commit the changed `*.hashes` (and `Makefile` if the pin moved). Never commit plaintext `.txt` lists.

Daily CI (`.github/workflows/sync-wordlists.yml`) checks for upstream changes and opens a PR when digests would change.

## Probe membership

```bash
make check-word WORD=example
```

Uses `en.hashes` by default (`WORDLIST_HASHES=…` to override).

## Local plaintext (optional / legacy)

`Maintainer/*.txt` remains gitignored for ad-hoc experiments:

```bash
make hash-wordlist          # Maintainer/en.txt → en.hashes
make reveal-wordlist        # print local plaintext if present
```

Prefer `make sync-wordlists` for anything you ship.

## Attribution

See [THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md). Corpus fixes belong upstream via PR to coffee-and-fun/google-profanity-words.
