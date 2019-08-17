//
//  main.swift
//  ConcertFinder
//
//  Created by Ryan Krol on 03/12/2018.
//

import Foundation

import ConcertFinderLib
import class SwiftToolbox.ConfigHandler
import class SwiftToolbox.EmailHandler
import class SwiftToolbox.StringUtils
import struct SwiftToolbox.EmailConfig

let configFile = "./../../ConcertFinderLib/Config.json"
let emailConfigFile = "./../../ConcertFinderLib/EmailConfig.json"

do {

    let config = try ConfigHandler<Config>(configFile: configFile, relativeFrom: #file).load()
    let emailConfig = try ConfigHandler<EmailConfig>(configFile: emailConfigFile, relativeFrom: #file).load()

    let emailClient = EmailHandler(config: emailConfig)

    for user in try config.getUsers() {

        var emailContent = ""

        StringUtils.appendWithNewline(&emailContent, newContent: "******************")
        StringUtils.appendWithNewline(&emailContent, newContent: "Data for user: \(user.username)")

        let artists = try FetchArtists.getFinishedArtistList(
            username: user.username,
            listeningThresholds: user.getListeningThresholds()
        )

        let artistInfo = try FetchArtistInformation.getArtistIds(
            artistNames: artists
        )

        let artistConcertInfo = try FetchConcertInformation.getArtistsConertInformation(
            cities: user.getCities(),
            filterCitiesBycountries: user.getFilteringCountries(),
            countries: user.getCountries(),
            artists: artistInfo
        )

        for artistConcerts in artistConcertInfo {
            for event in artistConcerts.value {
                StringUtils.appendWithNewline(&emailContent, newContent: artistConcerts.key)
                StringUtils.appendWithNewline(&emailContent, newContent: "==================")
                StringUtils.appendWithNewline(&emailContent, newContent: event.getLocation())
                StringUtils.appendWithNewline(&emailContent, newContent: event.getDate())
                StringUtils.appendWithNewline(&emailContent, newContent: event.getUrl())
                StringUtils.appendWithNewline(&emailContent, newContent: "==================\n")
            }
        }

        emailClient.sendMail(
            coreUser: user.emailList.first!,
            subject: "Concerts for the week",
            emailList: Array(user.emailList.dropFirst()),
            content: emailContent
        )

    }

} catch {
    print(error)
}
