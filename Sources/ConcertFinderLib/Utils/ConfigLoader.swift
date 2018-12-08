//
//  ConfigLoader.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 08/12/2018.
//
//  TV: Ashes To Ashes - Season 2 - Episode 5

import Foundation
import Configuration
import SwiftyJSON

public class ConfigLoader {

    private static let topLevelConfigKey = "config"

    public static func load() throws -> Config {

        let manager = ConfigurationManager().load(
            file: "/Users/ryankrol/Desktop/ConcertFinder/Sources/ConcertFinderLib/config.json"
        )

        // Load our Config
        guard let users = manager[topLevelConfigKey] else {
            throw CommonError.CouldNotLoadConfig
        }

        let jsonUsers = JSON(users)
        let jsonData = try jsonUsers.rawData()
        let config = try JSONDecoder().decode(Config.self, from: jsonData)

        return config
    }
}
