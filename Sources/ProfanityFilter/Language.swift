// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

import NaturalLanguage

/// Bundled word-list languages.
///
/// The `rawValue` is the resource stem for `Resources/WordLists/<rawValue>.hashes`.
/// Add a case and a matching digest file to ship another language.
public enum Language: String, Sendable, CaseIterable, Hashable {
  /// English (`en.hashes`).
  case english = "en"

  init?(nlLanguage: NLLanguage) {
    switch nlLanguage {
    case .english:
      self = .english
    default:
      return nil
    }
  }
}
