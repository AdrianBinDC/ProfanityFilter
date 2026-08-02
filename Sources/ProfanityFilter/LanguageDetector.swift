// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

import NaturalLanguage

enum LanguageDetector {
  /// Below this length, automatic detection is skipped (too unreliable).
  static let minimumCharacterCount = 24

  /// Minimum dominant-language confidence required to leave the fallback.
  static let minimumConfidence = 0.35

  static func resolve(_ string: String, fallback: Language) -> Language {
    let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
    guard trimmed.count >= minimumCharacterCount else {
      return fallback
    }

    return detect(in: trimmed) ?? fallback
  }

  private static func detect(in string: String) -> Language? {
    let recognizer = NLLanguageRecognizer()
    recognizer.processString(string)

    guard let dominant = recognizer.dominantLanguage else {
      return nil
    }

    let confidence = recognizer.languageHypotheses(withMaximum: 1)[dominant] ?? 0
    guard confidence >= minimumConfidence else {
      return nil
    }

    return Language(nlLanguage: dominant)
  }
}
