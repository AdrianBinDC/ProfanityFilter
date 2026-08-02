// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

public extension String {
  /// Returns a censored copy using ``ProfanityFilter/default``.
  ///
  /// Prefer configuring a ``ProfanityFilter`` when you need a custom
  /// ``Replacement`` or ``LanguageMode``.
  func censored() -> String {
    censored(using: .default)
  }

  /// Returns a censored copy using the provided filter.
  func censored(using filter: ProfanityFilter) -> String {
    filter.censor(self)
  }

  /// Legacy entry point. Prefer ``censored()``.
  @available(*, deprecated, renamed: "censored()")
  func cleanUp() -> String {
    censored()
  }
}
