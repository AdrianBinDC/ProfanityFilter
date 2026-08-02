// Copyright (c) 2018 Adrian Bolinger
// SPDX-License-Identifier: MIT

/// A configurable profanity filter for Apple platforms.
///
/// The matching engine will move to an init-once digest `Set` in a follow-up;
/// this package skeleton preserves existing censor behavior behind a modern API.
public struct ProfanityFilter: Sendable {
  /// Shared default filter (emoji replacement, bundled English list behavior).
  public static let `default` = ProfanityFilter()

  public init() {}

  /// Returns a copy of `string` with known profanity replaced.
  public func censor(_ string: String) -> String {
    LegacyRegexCensor.censor(string)
  }

  /// Legacy entry point. Prefer ``censor(_:)`` or `String.censored()`.
  @available(*, deprecated, message: "Use ProfanityFilter.censor(_:) or String.censored()")
  public static func cleanUp(_ string: String) -> String {
    ProfanityFilter.default.censor(string)
  }
}
