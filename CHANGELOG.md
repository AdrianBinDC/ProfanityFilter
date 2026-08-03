# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] — 2026-08-02

### Added

- Bundled word lists for English, Spanish, French, Irish, Arabic, and Chinese
- `make sync-wordlists` to refresh digests from [coffee-and-fun/google-profanity-words](https://github.com/coffee-and-fun/google-profanity-words)
- Daily GitHub Actions workflow that opens a PR when upstream releases change digests
- MIT third-party attribution in `THIRD_PARTY_NOTICES.md`

## [1.0.0] — 2026-08-02

### Added

- Configurable `ProfanityFilter` with `Replacement` (repeating / fixed / custom)
- Init-once `MatchIndex` matching over salted HMAC digests (English list bundled)
- `LanguageMode` (fixed / automatic / allBundled) via NaturalLanguage
- `String.censored()` convenience; deprecated `cleanUp` aliases
- Swift 6.3 tools, Apple multi-platform floors, GitHub Actions CI

[1.1.0]: https://github.com/AdrianBinDC/ProfanityFilter/releases/tag/1.1.0
[1.0.0]: https://github.com/AdrianBinDC/ProfanityFilter/releases/tag/1.0.0
