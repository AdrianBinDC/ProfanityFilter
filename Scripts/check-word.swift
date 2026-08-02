#!/usr/bin/env swift
// Checks whether a candidate word hashes into a .hashes file.
// Usage: swift Scripts/check-word.swift <word> <file.hashes>

import CryptoKit
import Foundation

guard CommandLine.arguments.count == 3 else {
  fputs("Usage: swift Scripts/check-word.swift <word> <file.hashes>\n", stderr)
  exit(1)
}

let word = CommandLine.arguments[1]
let hashesURL = URL(fileURLWithPath: CommandLine.arguments[2])
let salt = Data("ProfanityFilter.v1".utf8)
let normalized = word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
let mac = HMAC<SHA256>.authenticationCode(for: Data(normalized.utf8), using: SymmetricKey(data: salt))
let hex = Data(mac).map { String(format: "%02x", $0) }.joined()
let tokenCount = normalized.split(whereSeparator: \.isWhitespace).count
let needle = "\(hex) \(tokenCount)"

let contents = try String(contentsOf: hashesURL, encoding: .utf8)
let found = contents.split(whereSeparator: \.isNewline).contains { $0 == needle[...] }
print(found ? "HIT \(needle)" : "MISS \(needle)")
exit(found ? 0 : 2)
