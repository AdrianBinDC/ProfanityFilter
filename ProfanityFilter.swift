//
//  ProfanityFilter.swift
//
// Copyright 2018 Adrian Bolinger
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify,
// merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be included in all copies
// or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import Foundation

// Usage:
// yourLabel.text = ProfanityFilter.cleanUp("your string")

class ProfanityFilter: NSObject {
  
  /* Words from https://www.freewebheaders.com/full-list-of-bad-words-banned-by-google/ */
  
  static func cleanUp(_ string: String) -> String {
    let dirtyWords = "\\b(2g1c|2 girls 1 cup|acrotomophilia|alabama hot pocket|alaskan pipeline|anal|anilingus|anus|apeshit|arsehole|ass|asshole|assmunch|auto erotic|autoerotic|babeland|baby batter|baby juice|ball gag|ball gravy|ball kicking|ball licking|ball sack|ball sucking|bangbros|bareback|barely legal|barenaked|bastard|bastardo|bastinado|bbw|bdsm|beaner|beaners|beaver cleaver|beaver lips|bestiality|big black|big breasts|big knockers|big tits|bimbos|birdlock|bitch|bitches|black cock|blonde action|blonde on blonde action|blowjob|blow job|blow your load|blue waffle|blumpkin|bollocks|bondage|boner|boob|boobs|booty call|brown showers|brunette action|bukkake|bulldyke|bullet vibe|bullshit|bung hole|bunghole|busty|butt|buttcheeks|butthole|camel toe|camgirl|camslut|camwhore|carpet muncher|carpetmuncher|chocolate rosebuds|circlejerk|cleveland steamer|clit|clitoris|clover clamps|clusterfuck|cock|cocks|coprolagnia|coprophilia|cornhole|coon|coons|creampie|cum|cumming|cunnilingus|cunt|darkie|date rape|daterape|deep throat|deepthroat|dendrophilia|dick|dildo|dingleberry|dingleberries|dirty pillows|dirty sanchez|doggie style|doggiestyle|doggy style|doggystyle|dog style|dolcett|domination|dominatrix|dommes|donkey punch|double dong|double penetration|dp action|dry hump|dvda|eat my ass|ecchi|ejaculation|erotic|erotism|escort|eunuch|faggot|fecal|felch|fellatio|feltch|female squirting|femdom|figging|fingerbang|fingering|fisting|foot fetish|footjob|frotting|fuck|fuck buttons|fuckin|fucking|fucktards|fudge packer|fudgepacker|futanari|gang bang|gay sex|genitals|giant cock|girl on|girl on top|girls gone wild|goatcx|goatse|god damn|gokkun|golden shower|goodpoop|goo girl|goregasm|grope|group sex|g-spot|guro|hand job|handjob|hard core|hardcore|hentai|homoerotic|honkey|hooker|hot carl|hot chick|how to kill|how to murder|huge fat|humping|incest|intercourse|jack off|jail bait|jailbait|jelly donut|jerk off|jigaboo|jiggaboo|jiggerboo|jizz|juggs|kike|kinbaku|kinkster|kinky|knobbing|leather restraint|leather straight jacket|lemon party|lolita|lovemaking|make me come|male squirting|masturbate|menage a trois|mf|milf|missionary position|mofo|motherfucker|mound of venus|mr hands|muff diver|muffdiving|nambla|nawashi|negro|neonazi|nigga|nigger|nig nog|nimphomania|nipple|nipples|nsfw images|nude|nudity|nympho|nymphomania|octopussy|omorashi|one cup two girls|one guy one jar|orgasm|orgy|paedophile|paki|panties|panty|pedobear|pedophile|pegging|penis|phone sex|piece of shit|pissing|piss pig|pisspig|playboy|pleasure chest|pole smoker|ponyplay|poof|poon|poontang|punany|poop chute|poopchute|porn|porno|pornography|prince albert piercing|pthc|pubes|pussy|queaf|queef|quim|raghead|raging boner|rape|raping|rapist|rectum|reverse cowgirl|rimjob|rimming|rosy palm|rosy palm and her 5 sisters|rusty trombone|sadism|santorum|scat|schlong|scissoring|semen|sex|sexo|sexy|shaved beaver|shaved pussy|shemale|shibari|shit|shitblimp|shitty|shota|shrimping|skeet|slanteye|slut|s&m|smut|snatch|snowballing|sodomize|sodomy|spic|splooge|splooge moose|spooge|spread legs|spunk|strap on|strapon|strappado|strip club|style doggy|suck|sucks|suicide girls|sultry women|swastika|swinger|tainted love|taste my|tea bagging|threesome|throating|tied up|tight white|tit|tits|titties|titty|tongue in a|topless|tosser|towelhead|tranny|tribadism|tub girl|tubgirl|tushy|twat|twink|twinkie|two girls one cup|undressing|upskirt|urethra play|urophilia|vagina|venus mound|vibrator|violet wand|vorarephilia|voyeur|vulva|wank|wetback|wet dream|white power|wrapping men|wrinkled starfish|xx|xxx|yaoi|yellow showers|yiffy|zoophilia|🖕)\\b"
    
    func matches(for regex: String, in text: String) -> [String] {
      
      do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.compactMap {
          Range($0.range, in: text).map { String(text[$0]) }
        }
      } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
      }
    }
    
    let dirtyWordMatches = matches(for: dirtyWords, in: string)
    
    if dirtyWordMatches.count == 0 {
      return string
    } else {
      var newString = string
      
      dirtyWordMatches.forEach({ dirtyWord in
        let newWord = String(repeating: "😲", count: dirtyWord.count)
        newString = newString.replacingOccurrences(of: dirtyWord, with: newWord, options: [.caseInsensitive])
      })
      
      return newString
    }
  }
}
