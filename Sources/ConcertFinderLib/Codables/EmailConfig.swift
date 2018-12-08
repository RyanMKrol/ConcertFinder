//
//  EmailConfig.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 08/12/2018.
//
//  TV: Ashes To Ashes - Season 2 - Episode 8

import Foundation

public struct EmailConfig: Decodable {
    let emailAccount: String
    let password: String
    let hostName: String
}
