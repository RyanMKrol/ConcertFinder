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
    public let countries: [String]
    public let username: String
    public let filterCitiesBycountries: [String]
    private let listeningThresholds: ListeningThresholds

    public func getListeningThresholds() throws -> [String:Int] {
        return try self.listeningThresholds.getThresholds()
    }
}

private struct ListeningThresholds: Decodable {
    enum CodingKeys: String, CodingKey {
        case sevenDay = "7day"
        case oneMonth = "1month"
        case threeMonth = "3month"
        case sixMonth = "6month"
        case oneYear = "1year"
        case overall = "overall"
    }

    private let sevenDay: Int?
    private let oneMonth: Int?
    private let threeMonth: Int?
    private let sixMonth: Int?
    private let oneYear: Int?
    private let overall: Int?

    public func getThresholds() throws -> [String:Int] {

        let dict: [String: Int] = [
            CodingKeys.sevenDay.rawValue: self.sevenDay,
            CodingKeys.oneMonth.rawValue: self.oneMonth,
            CodingKeys.threeMonth.rawValue: self.threeMonth,
            CodingKeys.sixMonth.rawValue: self.sixMonth,
            CodingKeys.oneYear.rawValue: self.oneYear,
            CodingKeys.overall.rawValue: self.overall
        ].filter({$0.value != nil}) as! [String:Int]

        guard dict.count > 0 else {
            throw CommonError.NoListeningThresholdsFound
        }

        return dict
    }
}
