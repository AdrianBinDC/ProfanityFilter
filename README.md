# ProfanityFilter
Profanity filter written in Swift using NSRegularExpressions

Example usage:

    let testWord = "naughty"

    // returns "😲😲😲😲😲😲😲"
    let cleanedUpWord = ProfanityFilter.cleanUp(testWord)
