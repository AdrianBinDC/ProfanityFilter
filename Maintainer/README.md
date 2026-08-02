# Maintainer word lists

Plaintext corpora live here locally and are **gitignored**.

1. Edit `Maintainer/en.txt` (one word/phrase per line; `#` comments allowed)
2. Run `make hash-wordlist` to regenerate `Sources/ProfanityFilter/Resources/WordLists/en.hashes`
3. Commit only the `.hashes` file

Probe membership without printing the corpus:

```bash
make check-word WORD=example
```
