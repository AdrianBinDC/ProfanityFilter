// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

/// A configurable, init-once profanity filter for Apple platforms.
public struct ProfanityFilter: Sendable {
  /// Shared default filter (emoji replacement + bundled English list).
  public static let `default` = ProfanityFilter()

  public let replacement: Replacement
  public let wordList: WordList

  private let index: MatchIndex

  public init(
    replacement: Replacement = .default,
    wordList: WordList = .bundled(for: .english)
  ) {
    self.replacement = replacement
    self.wordList = wordList
    index = MatchIndex(wordList: wordList)
  }

  /// Returns a copy of `string` with known profanity replaced.
  public func censor(_ string: String) -> String {
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
}
