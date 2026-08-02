

# ProfanityFilter
Filtro de lenguaje inapropiado escrito en Swift utilizando NSRegularExpressions

Ejemplo de uso:

    let testWord = "naughty"

    // returns "😲😲😲😲😲😲😲"
    let cleanedUpWord = ProfanityFilter.cleanUp(testWord)
