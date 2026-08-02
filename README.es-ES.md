# ProfanityFilter

Filtro de lenguaje inapropiado configurable, en el dispositivo, para plataformas Apple. Construye un índice una vez (digests con sal) y sustituye coincidencias con el estilo que elijas.

[English](README.md)

## Requisitos

- Swift 6.3+
- iOS 18+ / macOS 15+ / tvOS 18+ / watchOS 11+ / visionOS 2+

## Instalación

Añade el paquete en Xcode (**File → Add Package Dependencies…**) o en `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/AdrianBinDC/ProfanityFilter.git", from: "1.0.0"),
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

La v1 incluye una lista en inglés. La detección queda lista para más idiomas después.

```swift
// Siempre inglés (predeterminado)
ProfanityFilter(languageMode: .fixed(.english))

// Detectar con NaturalLanguage; usar fallback si el texto es corto o la confianza es baja
ProfanityFilter(languageMode: .automatic(fallback: .english))

// Unión de todas las listas incluidas (más costoso; útil con texto mezclado)
ProfanityFilter(languageMode: .allBundled)
```

**Aviso**

- Cadenas muy cortas son poco fiables para detectar idioma. `.automatic` usa el fallback bajo un mínimo de longitud / confianza.
- Texto mezclado es difícil; usa `.fixed` o `.allBundled` cuando conozcas el caso.
- Aún no se incluyen listas que no sean inglés — añadir una después es un recurso hasheado más un caso de `Language`.

## Listas de palabras en el repositorio

Las listas incluidas son **digests HMAC-SHA256**, no texto plano. Evita guardar lenguaje ofensivo en git; es higiene, no secreto (con sal pública se pueden sondear diccionarios conocidos).

Quien mantiene el paquete guarda el texto plano local en `Maintainer/` (ignorado por git). Ver [Maintainer/README.md](Maintainer/README.md).

## Desarrollo

```bash
make lint          # SwiftLint
make format        # SwiftFormat (escribe)
make format-check  # SwiftFormat --lint (CI)
make test          # swift test
```

CI ejecuta los mismos targets de Make en GitHub Actions (`lint` / `format` / `test`).

Abre `Package.swift` en Xcode, elige el scheme **ProfanityFilter** (y su test plan compartido), destino **My Mac**, luego ⌘U.

## Licencia

MIT. Ver [LICENSE](LICENSE).
