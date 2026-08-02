// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

@testable import ProfanityFilter
import Testing

@Suite("LanguageMode")
struct LanguageModeTests {
  @Test("fixed English uses the bundled English list")
  func fixedEnglish() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      languageMode: .fixed(.english)
    )
    #expect(filter.censor("fuck") == "****")
    #expect(filter.censor("hello") == "hello")
  }

  @Test("allBundled includes the English list while only English is shipped")
  func allBundledIncludesEnglish() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      languageMode: .allBundled
    )
    #expect(filter.censor("fuck") == "****")
  }

  @Test("automatic falls back for very short text")
  func automaticFallsBackForShortText() {
    let short = "fuck"
    #expect(short.count < LanguageDetector.minimumCharacterCount)

    let resolved = LanguageDetector.resolve(short, fallback: .english)
    #expect(resolved == .english)

    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      languageMode: .automatic(fallback: .english)
    )
    #expect(filter.censor(short) == "****")
  }

  @Test("automatic with longer English text still censors with English list")
  func automaticLongerEnglishText() {
    let text = "This is a longer English sample that should be detectable as English: fuck"
    #expect(text.count >= LanguageDetector.minimumCharacterCount)

    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      languageMode: .automatic(fallback: .english)
    )
    #expect(filter.censor(text).contains("****"))
    #expect(!filter.censor(text).contains("fuck"))
  }

  @Test("skipped detection path matches fixed fallback behavior")
  func detectionFallbackMatchesFixed() {
    let short = "fuck"
    let automatic = ProfanityFilter(
      replacement: .repeating("*"),
      languageMode: .automatic(fallback: .english)
    )
    let fixed = ProfanityFilter(
      replacement: .repeating("*"),
      languageMode: .fixed(.english)
    )
    #expect(automatic.censor(short) == fixed.censor(short))
  }

  @Test("custom wordList init ignores language mode")
  func customWordListIgnoresLanguageMode() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: WordList(words: ["red"])
    )
    #expect(filter.languageMode == nil)
    #expect(filter.censor("red") == "***")
    #expect(filter.censor("fuck") == "fuck")
  }

  @Test("default filter uses fixed English")
  func defaultFilterUsesFixedEnglish() {
    #expect(ProfanityFilter.default.languageMode == .fixed(.english))
    #expect(ProfanityFilter.default.censor("fuck") == String(repeating: "😲", count: 4))
  }
}
