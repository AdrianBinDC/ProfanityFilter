// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

import Synchronization

/// Process-wide cache of bundled ``MatchIndex`` values (built once per language).
enum BundledMatchIndices {
  private struct State: Sendable {
    var indicesByLanguage: [Language: MatchIndex] = [:]
    var allBundledIndex: MatchIndex?
  }

  private static let state = Mutex(State())

  static func index(for language: Language) -> MatchIndex {
    state.withLock { state in
      if let cached = state.indicesByLanguage[language] {
        return cached
      }

      let index = MatchIndex(wordList: .bundled(for: language))
      state.indicesByLanguage[language] = index
      return index
    }
  }

  static func allBundled() -> MatchIndex {
    state.withLock { state in
      if let cached = state.allBundledIndex {
        return cached
      }

      let index = MatchIndex(wordList: .allBundled())
      state.allBundledIndex = index
      return index
    }
  }

  static func index(for mode: LanguageMode, text: String) -> MatchIndex {
    switch mode {
    case let .fixed(language):
      return index(for: language)
    case let .automatic(fallback):
      let language = LanguageDetector.resolve(text, fallback: fallback)
      return index(for: language)
    case .allBundled:
      return allBundled()
    }
  }
}
