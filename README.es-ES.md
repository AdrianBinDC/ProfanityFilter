# ProfanityFilter

[![CI](https://github.com/AdrianBinDC/ProfanityFilter/actions/workflows/ci.yml/badge.svg)](https://github.com/AdrianBinDC/ProfanityFilter/actions/workflows/ci.yml)
[![Swift 6.3+](https://img.shields.io/badge/Swift-6.3+-F05138?logo=swift&logoColor=white)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platforms-iOS%2018%20%7C%20macOS%2015%20%7C%20tvOS%2018%20%7C%20watchOS%2011%20%7C%20visionOS%202-lightgrey)](Package.swift)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/AdrianBinDC/ProfanityFilter)](https://github.com/AdrianBinDC/ProfanityFilter/releases)

Filtro de lenguaje inapropiado configurable, en el dispositivo, para plataformas Apple. Construye un índice una vez (digests con sal) y sustituye coincidencias con el estilo que elijas.

[English](README.md) · [Changelog](CHANGELOG.md)

## Requisitos

- Swift 6.3+
- iOS 18+ / macOS 15+ / tvOS 18+ / watchOS 11+ / visionOS 2+

Los mínimos de plataforma siguen a `Synchronization.Mutex` (concurrencia de Swift 6). Versiones anteriores no están soportadas.

## Instalación

Añade el paquete en Xcode (**File → Add Package Dependencies…**) o en `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/AdrianBinDC/ProfanityFilter.git", from: "1.1.0"),
],
```

Luego declara el producto:

```swift
.product(name: "ProfanityFilter", package: "ProfanityFilter"),
```

## Uso rápido

```swift
import ProfanityFilter

// Predeterminado: emoji + lista en inglés incluida
let cleaned = ProfanityFilter.default.censor("What the fuck?")
// "What the 😲😲😲😲?"

// Azúcar en String
let also = "What the fuck?".censored()
```

`cleanUp` sigue funcionando pero está deprecado — usa `censor` / `censored()`.

## Personalización

### Estilo de sustitución

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

### Listas personalizadas

```swift
var list = WordList(words: ["red", "hot pink"])
list = list.inserting(["green"]).removing(["red"])

let filter = ProfanityFilter(
  replacement: .repeating("*"),
  wordList: list,
)
filter.censor("a hot pink car") // "a ******** car"
```

Una `wordList` personalizada ignora la detección de idioma: ese filtro siempre usa tu lista.

## Modo de idioma

### Idiomas soportados

| Idioma | Caso `Language` | Recurso |
|--------|-----------------|---------|
| Inglés | `.english` | `en.hashes` |
| Español | `.spanish` | `es.hashes` |
| Francés | `.french` | `fr.hashes` |
| Irlandés | `.irish` | `ga.hashes` |
| Árabe | `.arabic` | `ar.hashes` |
| Chino | `.chinese` | `zh.hashes` |

```swift
// Siempre inglés (predeterminado)
ProfanityFilter(languageMode: .fixed(.english))

// Lista en español
ProfanityFilter(languageMode: .fixed(.spanish))

// Detectar con NaturalLanguage; usar fallback si el texto es corto o la confianza es baja
ProfanityFilter(languageMode: .automatic(fallback: .english))

// Unión de todas las listas incluidas (más costoso; útil con texto mezclado)
ProfanityFilter(languageMode: .allBundled)
```


**Aviso**

- Cadenas muy cortas son poco fiables para detectar idioma. `.automatic` usa el fallback bajo un mínimo de longitud / confianza.
- Texto mezclado es difícil; usa `.fixed` o `.allBundled` cuando conozcas el caso.

## Listas de palabras en el repositorio

Las listas incluidas son **digests HMAC-SHA256**, no texto plano. Los corpus se sincronizan desde [coffee-and-fun/google-profanity-words](https://github.com/coffee-and-fun/google-profanity-words) (MIT) — ver [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

```bash
make sync-wordlists   # ajusta UPSTREAM_REF en el Makefile si hace falta
```

CI diario abre un PR cuando un release upstream cambiaría los digests. Detalles: [Maintainer/README.md](Maintainer/README.md).

## Desarrollo

```bash
make lint              # SwiftLint
make format            # SwiftFormat (escribe)
make format-check      # SwiftFormat --lint (CI)
make test              # swift test
make sync-wordlists    # refresca *.hashes desde upstream
```

CI ejecuta lint / format / test en GitHub Actions, más un workflow programado de sync.

Abre `Package.swift` en Xcode, elige el scheme **ProfanityFilter** (y su test plan compartido), destino **My Mac**, luego ⌘U.

## Licencia

MIT. Ver [LICENSE](LICENSE). Atribución del corpus: [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
