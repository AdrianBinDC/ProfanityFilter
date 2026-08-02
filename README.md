# ProfanityFilter

A configurable, on-device profanity filter for Apple platforms. Match once against an init-built index of salted word digests; replace matches with a style you choose.

[Español](README.es-ES.md)

## Requirements

- Swift 6.3+
- iOS 18+ / macOS 15+ / tvOS 18+ / watchOS 11+ / visionOS 2+

## Installation

Add the package in Xcode (**File → Add Package Dependencies…**) or in `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/AdrianBinDC/ProfanityFilter.git", from: "1.0.0"),
],
```

Then depend on the product:

```swift
.product(name: "ProfanityFilter", package: "ProfanityFilter"),
```

## Quick start

```swift
import ProfanityFilter

// Shared default: emoji replacement + bundled English list
let cleaned = ProfanityFilter.default.censor("What the fuck?")
// "What the 😲😲😲😲?"

// String sugar
let also = "What the fuck?".censored()
```

`cleanUp` still works but is deprecated — prefer `censor` / `censored()`.

## Customization

### Replacement style

```swift
let stars = ProfanityFilter(
  replacement: .repeating("*"),
  languageMode: .fixed(.english),
)
stars.censor("fuck") // "****"

let fixed = ProfanityFilter(
  replacement: .fixed("[censored]"),
  languageMode: .fixed(.english),
)
fixed.censor("fuck") // "[censored]"

let bullets = ProfanityFilter(
  replacement: .custom { String(repeating: "•", count: $0.count) },
  languageMode: .fixed(.english),
)
```

### Custom word lists

```swift
var list = WordList(words: ["red", "hot pink"])
list = list.inserting(["green"]).removing(["red"])

let filter = ProfanityFilter(
  replacement: .repeating("*"),
  wordList: list,
)
filter.censor("a hot pink car") // "a ******** car"
```

A custom `wordList` ignores language detection — that filter always uses your list.

## Language mode

Bundled lists: English, Spanish, French, Irish, Arabic, and Chinese (`Language` cases).

```swift
// Always English (default)
ProfanityFilter(languageMode: .fixed(.english))

// Spanish list
ProfanityFilter(languageMode: .fixed(.spanish))

// Detect with NaturalLanguage; fall back when short / low confidence
ProfanityFilter(languageMode: .automatic(fallback: .english))

// Union of every bundled list (costlier; useful for mixed text)
ProfanityFilter(languageMode: .allBundled)
```

**Caveats**

- Very short strings are unreliable for detection (“fuck” alone may not look like English). `.automatic` uses the fallback below a minimum length / confidence.
- Mixed-language text is hard; prefer `.fixed` or `.allBundled` when you know the mix.

## Word lists in the repo

Bundled lists are **HMAC-SHA256 digests**, not plaintext. Corpora are synced from [coffee-and-fun/google-profanity-words](https://github.com/coffee-and-fun/google-profanity-words) (MIT) — see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). Digests are hygiene, not secrecy (a public salt means common dictionaries can still be probed).

```bash
make sync-wordlists   # bump UPSTREAM_REF in the Makefile first if needed
```

Daily CI opens a PR when upstream releases would change the digests. Details: [Maintainer/README.md](Maintainer/README.md).

## Development

```bash
make lint              # SwiftLint
make format            # SwiftFormat (write)
make format-check      # SwiftFormat --lint (CI)
make test              # swift test
make sync-wordlists    # refresh *.hashes from upstream
```

CI runs lint / format / test on GitHub Actions, plus a scheduled word-list sync workflow.

Open `Package.swift` in Xcode, select the **ProfanityFilter** scheme (and its shared test plan), destination **My Mac**, then ⌘U.

## License

MIT. See [LICENSE](LICENSE). Third-party corpus attribution: [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
