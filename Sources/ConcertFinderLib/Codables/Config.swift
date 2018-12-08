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

    private let users: [ConfigUser]

    /**
     Returns the users in the config, first validating whether the entries are valid

     - returns: The users found in the config
     - throws: When the config entry for any user is invalid
     */
    public func getUsers() throws -> [ConfigUser] {
        try self.isValidConfig()
        return self.users
    }

    /**
     Returns whether the config value we have is valid

     - returns: A boolean indicating a valid/invalid config
     */
    public func isValidConfig() throws {
        for user in self.users {
            let citiesCount = user.getCities().count
            let countriesCount = user.getCountries().count
            let listeningThresholdsCount = user.getListeningThresholds().count

            if citiesCount + countriesCount == 0 {
                throw CommonError.NoMatchingLocations(
                    response: "You don't have any locations to track. # Cities = \(citiesCount), #Countries = \(countriesCount)"
                )
            }

            if listeningThresholdsCount == 0 {
                throw CommonError.NoListeningThresholdsFound(response: "You don't have any thresholds defined to collect artists with.")
            }
        }
    }
}

public struct ConfigUser: Decodable {
    private let cities: [String]?
    private let countries: [String]?
    public let username: String
    private let filterCitiesBycountries: [String]?
    private let listeningThresholds: ListeningThresholds
    public let emailList: [String]

    /**
     Gets the cities we're tracking concerts for

     - returns: The cities we're tracking
     */
    public func getCities() -> [String] {
        return self.cities ?? []
    }

    /**
     Gets the countries we're tracking concerts for

     - returns: The countries we're tracking
     */
    public func getCountries() -> [String] {
        return self.countries ?? []
    }

    /**
     Gets the countries to filter cities by

     - returns: The filtering countries
     */
    public func getFilteringCountries() -> [String] {
        return self.filterCitiesBycountries ?? []
    }

    /**
     Gets the listening thresholds

     - returns: The listening thresholds
     - throws: When the config has no listening periods defined
     */
    public func getListeningThresholds() -> [String:Int] {
        return self.listeningThresholds.getThresholds()
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

    /**
     Gets the listening thresholds

     - returns: The listening thresholds
     - throws: When the config has no listening periods defined
     */
    public func getThresholds() -> [String:Int] {

        let dict: [String: Int] = [
            CodingKeys.sevenDay.rawValue: self.sevenDay,
            CodingKeys.oneMonth.rawValue: self.oneMonth,
            CodingKeys.threeMonth.rawValue: self.threeMonth,
            CodingKeys.sixMonth.rawValue: self.sixMonth,
            CodingKeys.oneYear.rawValue: self.oneYear,
            CodingKeys.overall.rawValue: self.overall
        ].filter({$0.value != nil}) as! [String:Int]

        return dict
    }
}
