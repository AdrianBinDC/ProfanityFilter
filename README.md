# ProfanityFilter
Profanity filter written in Swift 3 using NSRegularExpressions

Example usage:

    let testWord = "naughty"

    // returns "😲😲😲😲😲😲😲"
    let cleanedUpWord = ProfanityFilter.cleanUp(testWord)
