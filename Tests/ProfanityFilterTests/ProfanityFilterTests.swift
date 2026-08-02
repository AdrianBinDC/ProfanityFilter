// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

import Foundation
@testable import ProfanityFilter
import Testing

@Suite("ProfanityFilter skeleton")
struct ProfanityFilterTests {
  @Test("clean text is unchanged")
  func cleanTextUnchanged() {
    let input = "hello world"
    #expect(ProfanityFilter.default.censor(input) == input)
  }

  @Test("empty string is unchanged")
  func emptyStringUnchanged() {
    #expect(ProfanityFilter.default.censor("") == "")
  }

  @Test("known listed word is censored")
  func knownWordIsCensored() {
    let result = ProfanityFilter.default.censor("fuck")
    #expect(result != "fuck")
    #expect(result == String(repeating: "😲", count: 4))
  }

  @Test("String.censored uses the default filter")
  func stringCensoredConvenience() {
    #expect("hello".censored() == "hello")
    #expect("fuck".censored() == String(repeating: "😲", count: 4))
  }

  @Test("String.censored(using:) uses the provided filter")
  func stringCensoredUsingFilter() {
    let filter = ProfanityFilter()
    #expect("fuck".censored(using: filter) == filter.censor("fuck"))
  }

  @Test("deprecated cleanUp matches censor")
  func deprecatedCleanUpMatchesCensor() {
    let input = "fuck"
    let modern = ProfanityFilter.default.censor(input)
    #expect(ProfanityFilter.cleanUp(input) == modern)
    #expect(input.cleanUp() == modern)
  }
}
