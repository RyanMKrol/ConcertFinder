//
//  StringUtils.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 08/12/2018.
//
//  TV: Ashes To Ashes - Season 2 - Episode 8

import Foundation

public class StringUtils {

    private init(){}

    public static func appendWithNewline(_ source: inout String, newContent: String) {
        source.append(newContent)
        source.append("\n")
    }

}
