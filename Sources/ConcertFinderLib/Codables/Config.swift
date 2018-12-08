//
//  Config.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 08/12/2018.
//
//  TV: Ashes To Ashes - Season 2 - Episode 5

import Foundation

public struct Config: Decodable {
    enum CodingKeys: String, CodingKey {
        case users = "users"
    }
    public let users: [ConfigUser]
}

public struct ConfigUser: Decodable {
    public let cities: [String]
    public let username: String
    public let countries: [String]
    public let listeningThresholds: ListeningThresholds
}

public struct ListeningThresholds: Decodable {
    enum CodingKeys: String, CodingKey {
        case oneMonth = "1month"
        case sixMonth = "6month"
        case oneYear = "1year"
        case overall = "overall"
    }
    public let oneMonth: Int
    public let sixMonth: Int
    public let oneYear: Int
    public let overall: Int
}
