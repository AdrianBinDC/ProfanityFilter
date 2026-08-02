// Copyright (c) 2018-2026 Adrian Bolinger
// SPDX-License-Identifier: MIT

@testable import ProfanityFilter
import XCTest

/// XCTest anchor so Xcode's Test navigator can discover the test bundle.
/// Swift Testing cases live in ``ProfanityFilterTests``.
final class XCTestDiscoveryAnchor: XCTestCase {
  func testBundleLoads() {
    let filter = ProfanityFilter(
      replacement: .repeating("*"),
      wordList: WordList(words: ["red"])
    )
    XCTAssertEqual(filter.censor("ok"), "ok")
  }
}
