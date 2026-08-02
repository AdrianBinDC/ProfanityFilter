// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

import Foundation
@testable import ProfanityFilter
import Testing

@Suite("ProfanityFilter engine")
struct ProfanityFilterTests {
  private let toyList = WordList(words: ["red", "blue", "hot pink"])

  @Test("clean text is unchanged")
  func cleanTextUnchanged() {
    let filter = ProfanityFilter(wordList: toyList)
    #expect(filter.censor("hello world") == "hello world")
  }

  @Test("empty string is unchanged")
  func emptyStringUnchanged() {
    let filter = ProfanityFilter(wordList: toyList)
    #expect(filter.censor("") == "")
  }

  @Test("listed word is censored with repeating replacement")
  func listedWordCensored() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: toyList
    )
    #expect(filter.censor("red") == "***")
  }

  @Test("matching is case insensitive")
  func caseInsensitive() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: toyList
    )
    #expect(filter.censor("RED") == "***")
    #expect(filter.censor("Red") == "***")
  }

  @Test("word boundaries avoid embedded false positives")
  func wordBoundaries() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: WordList(words: ["ass"])
    )
    #expect(filter.censor("classic") == "classic")
    #expect(filter.censor("ass") == "***")
  }

  @Test("multi-match in one string")
  func multiMatch() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: toyList
    )
    #expect(filter.censor("red and blue") == "*** and ****")
  }

  @Test("phrase matching")
  func phraseMatching() {
    let filter = ProfanityFilter(
      replacement: .fixed("[x]"),
      wordList: toyList
    )
    #expect(filter.censor("a hot pink car") == "a [x] car")
  }

  @Test("fixed and custom replacements")
  func replacementStyles() {
    let fixed = ProfanityFilter(replacement: .fixed("[censored]"), wordList: toyList)
    #expect(fixed.censor("red") == "[censored]")

    let custom = ProfanityFilter(
      replacement: .custom { String(repeating: "•", count: $0.count) },
      wordList: toyList
    )
    #expect(custom.censor("blue") == "••••")
  }

  @Test("inserting and removing words")
  func insertingAndRemoving() {
    let base = WordList(words: ["red"])
    let expanded = base.inserting(["green"])
    let reduced = expanded.removing(["red"])

    #expect(ProfanityFilter(replacement: .repeating("*"), wordList: expanded).censor("green") == "*****")
    #expect(ProfanityFilter(replacement: .repeating("*"), wordList: reduced).censor("red") == "red")
  }

  @Test("String.censored conveniences")
  func stringConveniences() {
    let filter = ProfanityFilter(replacement: .repeating("*"), wordList: toyList)
    #expect("red".censored(using: filter) == "***")
    #expect("hello".censored(using: filter) == "hello")
  }

  @Test("bundled English list loads and censors a known word")
  func bundledEnglishList() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: .bundled(for: .english)
    )
    #expect(filter.censor("fuck") == "****")
    #expect(filter.censor("hello") == "hello")
  }

  @Test("bundled list digest file is non-empty")
  func bundledDigestFileNonEmpty() {
    let list = WordList.bundled(for: .english)
    guard case let .digests(entries) = list.storage else {
      Issue.record("Expected bundled digests storage")
      return
    }
    #expect(entries.count >= 300)
  }

  @Test("deprecated cleanUp matches censor")
  func deprecatedCleanUpMatchesCensor() {
    let input = "fuck"
    let modern = ProfanityFilter.default.censor(input)
    #expect(ProfanityFilter.cleanUp(input) == modern)
    #expect(input.cleanUp() == modern)
  }

  @Test("default emoji replacement length matches match")
  func defaultEmojiReplacement() {
    let result = ProfanityFilter.default.censor("fuck")
    #expect(result == String(repeating: "😲", count: 4))
  }
}
