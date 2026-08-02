// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

import Foundation
@testable import ProfanityFilter
import Testing

@Suite("ProfanityFilter engine")
struct ProfanityFilterTests {
  private static var toyList: WordList {
    WordList(words: ["red", "blue", "hot pink"])
  }

  @Test
  func `clean text is unchanged`() {
    let filter = ProfanityFilter(wordList: Self.toyList)
    #expect(filter.censor("hello world") == "hello world")
  }

  @Test
  func `empty string is unchanged`() {
    let filter = ProfanityFilter(wordList: Self.toyList)
    #expect(filter.censor("") == "")
  }

  @Test
  func `listed word is censored with repeating replacement`() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: Self.toyList,
    )
    #expect(filter.censor("red") == "***")
  }

  @Test
  func `matching is case insensitive`() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: Self.toyList,
    )
    #expect(filter.censor("RED") == "***")
    #expect(filter.censor("Red") == "***")
  }

  @Test
  func `word boundaries avoid embedded false positives`() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: WordList(words: ["ass"]),
    )
    #expect(filter.censor("classic") == "classic")
    #expect(filter.censor("ass") == "***")
  }

  @Test
  func `multi-match in one string`() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: Self.toyList,
    )
    #expect(filter.censor("red and blue") == "*** and ****")
  }

  @Test
  func `phrase matching`() {
    let filter = ProfanityFilter(
      replacement: .fixed("[x]"),
      wordList: Self.toyList,
    )
    #expect(filter.censor("a hot pink car") == "a [x] car")
  }

  @Test
  func `fixed and custom replacements`() {
    let fixed = ProfanityFilter(replacement: .fixed("[censored]"), wordList: Self.toyList)
    #expect(fixed.censor("red") == "[censored]")

    let custom = ProfanityFilter(
      replacement: .custom { String(repeating: "•", count: $0.count) },
      wordList: Self.toyList,
    )
    #expect(custom.censor("blue") == "••••")
  }

  @Test
  func `inserting and removing words`() {
    let base = WordList(words: ["red"])
    let expanded = base.inserting(["green"])
    let reduced = expanded.removing(["red"])

    #expect(ProfanityFilter(replacement: .repeating("*"), wordList: expanded).censor("green") == "*****")
    #expect(ProfanityFilter(replacement: .repeating("*"), wordList: reduced).censor("red") == "red")
  }

  @Test
  func `string censored conveniences`() {
    let filter = ProfanityFilter(replacement: .repeating("*"), wordList: Self.toyList)
    #expect("red".censored(using: filter) == "***")
    #expect("hello".censored(using: filter) == "hello")
  }

  @Test
  func `bundled English list loads and censors a known word`() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: .bundled(for: .english),
    )
    #expect(filter.censor("fuck") == "****")
    #expect(filter.censor("hello") == "hello")
  }

  @Test
  func `bundled list digest file is non-empty`() {
    let list = WordList.bundled(for: .english)
    guard case let .digests(entries) = list.storage else {
      Issue.record("Expected bundled digests storage")
      return
    }
    #expect(entries.count >= 300)
  }

  @Test
  func `deprecated cleanUp matches censor`() {
    let input = "fuck"
    let modern = ProfanityFilter.default.censor(input)
    #expect(ProfanityFilter.cleanUp(input) == modern)
    #expect(input.cleanUp() == modern)
  }

  @Test
  func `default emoji replacement length matches match`() {
    let result = ProfanityFilter.default.censor("fuck")
    #expect(result == String(repeating: "😲", count: 4))
  }
}
