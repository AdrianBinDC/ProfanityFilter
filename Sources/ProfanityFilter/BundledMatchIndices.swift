// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

import Foundation

/// Process-wide cache of bundled ``MatchIndex`` values (built once per language).
enum BundledMatchIndices {
  private static let lock = NSLock()
  private static var indicesByLanguage: [Language: MatchIndex] = [:]
  private static var allBundledIndex: MatchIndex?

  static func index(for language: Language) -> MatchIndex {
    lock.lock()
    defer { lock.unlock() }

    if let cached = indicesByLanguage[language] {
      return cached
    }

    let index = MatchIndex(wordList: .bundled(for: language))
    indicesByLanguage[language] = index
    return index
  }

  static func allBundled() -> MatchIndex {
    lock.lock()
    defer { lock.unlock() }

    if let cached = allBundledIndex {
      return cached
    }

    let index = MatchIndex(wordList: .allBundled())
    allBundledIndex = index
    return index
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
