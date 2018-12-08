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

    private init(){}

    private static let topLevelConfigKey = "config"
    private static let configFile = "/Users/ryankrol/Desktop/ConcertFinder/Sources/ConcertFinderLib/config.json"
    private static let emailConfigFile = "/Users/ryankrol/Desktop/ConcertFinder/Sources/ConcertFinderLib/emailConfig.json"

    /**
     Loads the application config

     - returns: The application configuration
     */
    public static func loadAppConfig() throws -> Config {
        let manager = ConfigurationManager().load(file: configFile)

        guard let appConfig = manager[topLevelConfigKey] else {
            throw CommonError.CouldNotLoadAppConfig
        }

        let jsonConfig = JSON(appConfig)
        let jsonData = try jsonConfig.rawData()
        let config = try JSONDecoder().decode(Config.self, from: jsonData)

        return config
    }

    /**
     Loads the email config

     - returns: The application configuration
     */
    public static func loadEmailConfig() throws -> EmailConfig {
        let manager = ConfigurationManager().load(file: emailConfigFile)

        guard let emailConfig = manager[topLevelConfigKey] else {
            throw CommonError.CouldNotLoadEmailConfig
        }

        let jsonConfig = JSON(emailConfig)
        let jsonData = try jsonConfig.rawData()
        let config = try JSONDecoder().decode(EmailConfig.self, from: jsonData)

        return config
    }
}
