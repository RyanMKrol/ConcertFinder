//
//  main.swift
//  ConcertFinder
//
//  Created by Ryan Krol on 03/12/2018.
//

import Foundation
import ConcertFinderLib

do {

    let config = try ConfigLoader.loadAppConfig()

    let emailConfig = try ConfigLoader.loadEmailConfig()
    let emailClient = EmailClient(config: emailConfig)

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

        emailClient.sendMail(emailList: user.emailList, content: emailContent)
    }

} catch {
    print(error)
}
