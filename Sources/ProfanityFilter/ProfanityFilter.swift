// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

/// A configurable, init-once profanity filter for Apple platforms.
public struct ProfanityFilter: Sendable {
  /// Shared default filter (emoji replacement + fixed English list).
  public static let `default` = ProfanityFilter()

  public let replacement: Replacement

  /// Language selection for bundled lists. `nil` when constructed with a custom ``WordList``.
  public let languageMode: LanguageMode?

  /// Custom word list when provided; otherwise bundled lists are selected via ``languageMode``.
  public let wordList: WordList?

  private let customIndex: MatchIndex?

  /// Creates a filter that selects bundled lists according to `languageMode`.
  public init(
    replacement: Replacement = .default,
    languageMode: LanguageMode = .fixed(.english)
  ) {
    self.replacement = replacement
    self.languageMode = languageMode
    wordList = nil
    customIndex = nil
  }

  /// Creates a filter that always uses a caller-provided word list (no language detection).
  public init(
    replacement: Replacement = .default,
    wordList: WordList
  ) {
    self.replacement = replacement
    languageMode = nil
    self.wordList = wordList
    customIndex = MatchIndex(wordList: wordList)
  }

  /// Returns a copy of `string` with known profanity replaced.
  public func censor(_ string: String) -> String {
    let index = resolveIndex(for: string)
    let ranges = index.matches(in: string)
    guard !ranges.isEmpty else { return string }

    var result = string
    for range in ranges.reversed() {
      let match = result[range]
      result.replaceSubrange(range, with: replacement.apply(to: match))
    }
    return result
  }

  /// Legacy entry point. Prefer ``censor(_:)`` or `String.censored()`.
  @available(*, deprecated, message: "Use ProfanityFilter.censor(_:) or String.censored()")
  public static func cleanUp(_ string: String) -> String {
    ProfanityFilter.default.censor(string)
  }

  private func resolveIndex(for string: String) -> MatchIndex {
    if let customIndex {
      return customIndex
    }

    let mode = languageMode ?? .fixed(.english)
    return BundledMatchIndices.index(for: mode, text: string)
  }
}
