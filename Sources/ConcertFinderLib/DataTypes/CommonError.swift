//
//  CommonError.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 08/12/2018.
//
//  TV: Ashes To Ashes - Season 2 - Episode 5

import Foundation

public enum CommonError: Error {
    case CouldNotLoadAppConfig
    case CouldNotLoadEmailConfig
    case NoListeningThresholdsFound(response: String)
    case NoMatchingLocations(response: String)
}
