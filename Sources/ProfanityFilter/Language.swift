// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

import NaturalLanguage

/// Bundled word-list languages.
///
/// The `rawValue` is the resource stem for `Resources/WordLists/<rawValue>.hashes`.
/// Digests are synced from coffee-and-fun/google-profanity-words via `make sync-wordlists`.
public enum Language: String, Sendable, CaseIterable, Hashable {
  /// English (`en.hashes`).
  case english = "en"
  /// Spanish (`es.hashes`).
  case spanish = "es"
  /// French (`fr.hashes`).
  case french = "fr"
  /// Irish (`ga.hashes`).
  case irish = "ga"
  /// Arabic (`ar.hashes`).
  case arabic = "ar"
  /// Chinese (`zh.hashes`).
  case chinese = "zh"

  init?(nlLanguage: NLLanguage) {
    switch nlLanguage {
    case .english:
      self = .english
    case .spanish:
      self = .spanish
    case .french:
      self = .french
    case .arabic:
      self = .arabic
    case .simplifiedChinese, .traditionalChinese:
      self = .chinese
    default:
      // Irish is not always exposed as a named NLLanguage constant.
      if nlLanguage.rawValue == "ga" {
        self = .irish
      } else {
        return nil
      }
    }
  }
}
