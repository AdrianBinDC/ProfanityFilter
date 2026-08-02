// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

@testable import ProfanityFilter
import Testing

@Suite("LanguageMode")
struct LanguageModeTests {
  @Test
  func `fixed English uses the bundled English list`() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      languageMode: .fixed(.english),
    )
    #expect(filter.censor("fuck") == "****")
    #expect(filter.censor("hello") == "hello")
  }

  @Test
  func `allBundled includes the English list while only English is shipped`() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      languageMode: .allBundled,
    )
    #expect(filter.censor("fuck") == "****")
  }

  @Test
  func `automatic falls back for very short text`() {
    let short = "fuck"
    #expect(short.count < LanguageDetector.minimumCharacterCount)

    let resolved = LanguageDetector.resolve(short, fallback: .english)
    #expect(resolved == .english)

    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      languageMode: .automatic(fallback: .english),
    )
    #expect(filter.censor(short) == "****")
  }

  @Test
  func `automatic with longer English text still censors with English list`() {
    let text = "This is a longer English sample that should be detectable as English: fuck"
    #expect(text.count >= LanguageDetector.minimumCharacterCount)

    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      languageMode: .automatic(fallback: .english),
    )
    #expect(filter.censor(text).contains("****"))
    #expect(!filter.censor(text).contains("fuck"))
  }

  @Test
  func `skipped detection path matches fixed fallback behavior`() {
    let short = "fuck"
    let automatic = ProfanityFilter(
      replacement: .repeating("*"),
      languageMode: .automatic(fallback: .english),
    )
    let fixed = ProfanityFilter(
      replacement: .repeating("*"),
      languageMode: .fixed(.english),
    )
    #expect(automatic.censor(short) == fixed.censor(short))
  }

  @Test
  func `custom wordList init ignores language mode`() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: WordList(words: ["red"]),
    )
    #expect(filter.languageMode == nil)
    #expect(filter.censor("red") == "***")
    #expect(filter.censor("fuck") == "fuck")
  }

  @Test
  func `default filter uses fixed English`() {
    #expect(ProfanityFilter.default.languageMode == .fixed(.english))
    #expect(ProfanityFilter.default.censor("fuck") == String(repeating: "😲", count: 4))
  }
}
