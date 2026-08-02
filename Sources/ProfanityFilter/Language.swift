// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

import NaturalLanguage

/// Bundled word-list languages. Add a `*.hashes` resource to extend.
public enum Language: String, Sendable, CaseIterable, Hashable {
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
