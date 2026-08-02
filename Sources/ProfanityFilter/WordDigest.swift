// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

import CryptoKit
import Foundation

enum WordDigest {
  /// Package salt for HMAC-SHA256 digests. Public on purpose — this is hygiene, not secrecy.
  static let salt = Data("ProfanityFilter.v1".utf8)

  static func normalize(_ word: String) -> String {
    word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
  }

  static func digest(forNormalizedWord word: String) -> Data {
    let mac = HMAC<SHA256>.authenticationCode(
      for: Data(word.utf8),
      using: SymmetricKey(data: salt),
    )
    return Data(mac)
  }

  static func digest(forRawWord word: String) -> Data {
    digest(forNormalizedWord: normalize(word))
  }

  static func hexString(for digest: Data) -> String {
    digest.map { String(format: "%02x", $0) }.joined()
  }

  static func data(fromHex hex: String) -> Data? {
    var data = Data(capacity: hex.count / 2)
    var index = hex.startIndex
    while index < hex.endIndex {
      let next = hex.index(index, offsetBy: 2, limitedBy: hex.endIndex) ?? hex.endIndex
      guard next > index, let byte = UInt8(hex[index ..< next], radix: 16) else { return nil }
      data.append(byte)
      index = next
    }
    return data
  }
}
