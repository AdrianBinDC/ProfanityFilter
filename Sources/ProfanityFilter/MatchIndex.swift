// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

import Foundation

/// Init-once matcher: single-token digests in a `Set`, multi-token phrases checked by windows.
struct MatchIndex: Sendable {
  struct Phrase: Sendable {
    let digest: Data
    let tokenCount: Int
  }

  let wordDigests: Set<Data>
  /// Longest-first for greedy window matching.
  let phrases: [Phrase]
  let maximumPhraseTokenCount: Int

  init(wordList: WordList) {
    var words = Set<Data>()
    var phraseMap: [Data: Int] = [:]

    switch wordList.storage {
    case let .words(rawWords):
      for word in rawWords {
        let tokenCount = word.split(whereSeparator: \.isWhitespace).count
        let digest = WordDigest.digest(forNormalizedWord: word)
        if tokenCount <= 1 {
          words.insert(digest)
        } else {
          phraseMap[digest] = tokenCount
        }
      }
    case let .digests(entries):
      for entry in entries {
        if entry.tokenCount <= 1 {
          words.insert(entry.digest)
        } else {
          phraseMap[entry.digest] = entry.tokenCount
        }
      }
    }

    wordDigests = words
    phrases = phraseMap
      .map { Phrase(digest: $0.key, tokenCount: $0.value) }
      .sorted { $0.tokenCount > $1.tokenCount }
    maximumPhraseTokenCount = phrases.first?.tokenCount ?? 0
  }

  func matches(in string: String) -> [Range<String.Index>] {
    let tokens = tokenize(string)
    guard !tokens.isEmpty else { return [] }

    var occupied = Array(repeating: false, count: tokens.count)
    var ranges: [Range<String.Index>] = []

    if maximumPhraseTokenCount >= 2 {
      for phrase in phrases {
        let size = phrase.tokenCount
        guard size <= tokens.count else { continue }
        var index = 0
        while index <= tokens.count - size {
          defer { index += 1 }
          if occupied[index ..< (index + size)].contains(true) {
            continue
          }
          let window = tokens[index ..< (index + size)]
          let joined = window.map(\.normalized).joined(separator: " ")
          let digest = WordDigest.digest(forNormalizedWord: joined)
          guard digest == phrase.digest else { continue }
          let start = window.first!.range.lowerBound
          let end = window.last!.range.upperBound
          ranges.append(start ..< end)
          for offset in index ..< (index + size) {
            occupied[offset] = true
          }
        }
      }
    }

    for (index, token) in tokens.enumerated() where !occupied[index] {
      let digest = WordDigest.digest(forNormalizedWord: token.normalized)
      if wordDigests.contains(digest) {
        ranges.append(token.range)
        occupied[index] = true
      }
    }

    return ranges.sorted { $0.lowerBound < $1.lowerBound }
  }

  private struct Token {
    let normalized: String
    let range: Range<String.Index>
  }

  private func tokenize(_ string: String) -> [Token] {
    var tokens: [Token] = []
    string.enumerateSubstrings(in: string.startIndex..., options: [.byWords, .localized]) { substring, range, _, _ in
      guard let substring else { return }
      let normalized = WordDigest.normalize(substring)
      guard !normalized.isEmpty else { return }
      tokens.append(Token(normalized: normalized, range: range))
    }
    return tokens
  }
}
