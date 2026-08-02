// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

/// How matched profanity is rewritten in the output string.
public enum Replacement: Sendable {
  /// Repeat `unit` until the replacement length matches the match (default unit: `😲`).
  ///
  /// For a single-character `unit`, the result length equals the match’s character count.
  case repeating(String)

  /// Always substitute this fixed string, regardless of match length.
  case fixed(String)

  /// Caller-provided substitution from the matched substring.
  case custom(@Sendable (Substring) -> String)

  /// Default historical behavior: one `😲` per character in the match.
  public static let `default` = Replacement.repeating("😲")

  func apply(to match: Substring) -> String {
    switch self {
    case let .repeating(unit):
      if unit.isEmpty {
        return ""
      }
      if unit.count == 1, let character = unit.first {
        return String(repeating: character, count: match.count)
      }
      return String(repeating: unit, count: match.count)
    case let .fixed(value):
      return value
    case let .custom(transform):
      return transform(match)
    }
  }
}
