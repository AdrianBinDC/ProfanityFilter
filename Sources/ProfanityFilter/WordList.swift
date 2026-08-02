// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

import Foundation

/// A set of words/phrases used to build a ``MatchIndex``.
public struct WordList: Sendable, Hashable {
  enum Storage: Hashable {
    case words(Set<String>)
    case digests([DigestEntry])
  }

  struct DigestEntry: Hashable {
    let digest: Data
    let tokenCount: Int
  }

  let storage: Storage

  /// Creates a list from plaintext words (normalized at index build time).
  public init(words: some Sequence<String>) {
    let normalized = Set(words.map(WordDigest.normalize).filter { !$0.isEmpty })
    storage = .words(normalized)
  }

  /// Loads the bundled hashed list for `language`.
  public static func bundled(for language: Language) -> WordList {
    guard let list = bundledIfPresent(for: language) else {
      preconditionFailure("Missing bundled word list for \(language.rawValue)")
    }
    return list
  }

  /// Union of every bundled language list that is present in the package resources.
  public static func allBundled() -> WordList {
    var combined: [DigestEntry] = []
    var seen = Set<Data>()

    for language in Language.allCases {
      guard case let .digests(entries) = bundledIfPresent(for: language)?.storage else {
        continue
      }
      for entry in entries where seen.insert(entry.digest).inserted {
        combined.append(entry)
      }
    }

    return WordList(storage: .digests(combined))
  }

  /// Loads a bundled list when the resource exists; otherwise `nil`.
  public static func bundledIfPresent(for language: Language) -> WordList? {
    // SPM `.process` may place files at the bundle root or under WordLists/.
    let url =
      Bundle.module.url(
        forResource: language.rawValue,
        withExtension: "hashes",
        subdirectory: "WordLists",
      ) ?? Bundle.module.url(
        forResource: language.rawValue,
        withExtension: "hashes",
      )
    guard let url else { return nil }
    return loadDigests(from: url)
  }

  public func inserting(_ words: some Sequence<String>) -> WordList {
    switch storage {
    case var .words(existing):
      for word in words {
        let normalized = WordDigest.normalize(word)
        if !normalized.isEmpty {
          existing.insert(normalized)
        }
      }
      return WordList(storage: .words(existing))
    case let .digests(entries):
      var map = Dictionary(uniqueKeysWithValues: entries.map { ($0.digest, $0) })
      for word in words {
        let normalized = WordDigest.normalize(word)
        guard !normalized.isEmpty else { continue }
        let digest = WordDigest.digest(forNormalizedWord: normalized)
        let tokenCount = normalized.split(whereSeparator: \.isWhitespace).count
        map[digest] = DigestEntry(digest: digest, tokenCount: tokenCount)
      }
      return WordList(storage: .digests(Array(map.values)))
    }
  }

  public func removing(_ words: some Sequence<String>) -> WordList {
    let toRemove = Set(words.map(WordDigest.normalize).filter { !$0.isEmpty })
    switch storage {
    case let .words(existing):
      return WordList(storage: .words(existing.subtracting(toRemove)))
    case let .digests(entries):
      let removeDigests = Set(toRemove.map(WordDigest.digest(forNormalizedWord:)))
      return WordList(storage: .digests(entries.filter { !removeDigests.contains($0.digest) }))
    }
  }

  private init(storage: Storage) {
    self.storage = storage
  }

  private static func loadDigests(from url: URL) -> WordList {
    guard let raw = try? String(contentsOf: url, encoding: .utf8) else {
      preconditionFailure("Unable to read word list at \(url.path)")
    }

    var entries: [DigestEntry] = []
    for line in raw.split(whereSeparator: \.isNewline) {
      let trimmed = line.trimmingCharacters(in: .whitespaces)
      if trimmed.isEmpty || trimmed.hasPrefix("#") {
        continue
      }
      let parts = trimmed.split(whereSeparator: \.isWhitespace)
      guard parts.count == 2,
            let digest = WordDigest.data(fromHex: String(parts[0])),
            let tokenCount = Int(parts[1]),
            tokenCount > 0
      else {
        preconditionFailure("Invalid hash line in \(url.lastPathComponent): \(trimmed)")
      }
      entries.append(DigestEntry(digest: digest, tokenCount: tokenCount))
    }
    return WordList(storage: .digests(entries))
  }
}
