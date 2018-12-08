//
//  RegexMatcher.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 08/12/2018.
//

import Foundation

public class RegexMatcher {

    /**
     Gets the number of matches for a regex pattern against a string

     - Parameter pattern: The regex pattern
     - Parameter target: The string to evaluate the regex against

     - returns: The number of matches
     */
    public static func numMatches(pattern: String, target: String) -> Int {
        let regex = try? NSRegularExpression(
            pattern: pattern,
            options: []
        )
        let matches = regex?.numberOfMatches(
            in: target,
            options: [],
            range: NSRange(location: 0, length: target.count)
        ) ?? 0

        return matches
    }

}
