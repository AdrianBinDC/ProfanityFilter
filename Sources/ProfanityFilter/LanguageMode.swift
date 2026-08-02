// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

/// Selects which bundled word list(s) to apply when censoring.
///
/// Only languages with a committed `*.hashes` resource are available. v1 ships
/// English; additional languages can be added without changing this enum’s cases
/// beyond a new ``Language`` value.
///
/// ### Automatic detection
///
/// ``automatic(fallback:)`` uses `NLLanguageRecognizer`. Short strings and
/// low-confidence hypotheses fall back to `fallback` — detection alone is not
/// reliable for a single expletive.
public enum LanguageMode: Sendable, Equatable {
  /// Detect the text language, then use that list when available.
  ///
  /// Short or low-confidence input uses `fallback` (defaults to English).
  case automatic(fallback: Language = .english)

  /// Always use the bundled list for this language.
  case fixed(Language)

  /// Apply every bundled language list (useful for mixed/unknown text).
  case allBundled
}
