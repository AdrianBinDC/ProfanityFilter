#!/usr/bin/env swift
// Hashes a plaintext word list into the committed digest format.
// Usage: swift Scripts/hash-wordlist.swift <plaintext.txt> <output.hashes>

import CryptoKit
import Foundation

guard CommandLine.arguments.count == 3 else {
  fputs("Usage: swift Scripts/hash-wordlist.swift <plaintext.txt> <output.hashes>\n", stderr)
  exit(1)
}

let inputURL = URL(fileURLWithPath: CommandLine.arguments[1])
let outputURL = URL(fileURLWithPath: CommandLine.arguments[2])

let salt = Data("ProfanityFilter.v1".utf8)

func normalize(_ word: String) -> String {
  word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
}

func digest(for normalized: String) -> String {
  let mac = HMAC<SHA256>.authenticationCode(for: Data(normalized.utf8), using: SymmetricKey(data: salt))
  return Data(mac).map { String(format: "%02x", $0) }.joined()
}

let raw = try String(contentsOf: inputURL, encoding: .utf8)
var lines: [String] = []

for line in raw.split(whereSeparator: \.isNewline) {
  let trimmed = line.trimmingCharacters(in: .whitespaces)
  if trimmed.isEmpty || trimmed.hasPrefix("#") { continue }
  let normalized = normalize(String(trimmed))
  guard !normalized.isEmpty else { continue }
  let tokenCount = normalized.split(whereSeparator: \.isWhitespace).count
  lines.append("\(digest(for: normalized)) \(tokenCount)")
}

lines.sort()
try lines.joined(separator: "\n").appending("\n").write(to: outputURL, atomically: true, encoding: .utf8)
fputs("Wrote \(lines.count) digests to \(outputURL.path)\n", stderr)
