//
//  main.swift
//  ConcertFinder
//
//  Created by Ryan Krol on 03/12/2018.
//

import Foundation
import ConcertFinderLib

do {
    let config = try ConfigLoader.load()

    for user in config.users {

        print("******************")
        print("Data for user: \(user.username)")

        let artists = try FetchArtists.getFinishedArtistList(
            username: user.username,
            listeningThresholds: user.getListeningThresholds()
        )

        let artistInfo = try FetchArtistInformation.getArtistIds(
            artistNames: artists
        )

        let artistConcertInfo = try FetchConcertInformation.getArtistsConertInformation(
            cities: user.cities,
            filterCitiesBycountries: user.filterCitiesBycountries,
            artists: artistInfo
        )

        for artistConcerts in artistConcertInfo {
            for event in artistConcerts.value {
                print(artistConcerts.key)
                print("==================")
                print(event.getLocation())
                print(event.getDate())
                print(event.getUrl())
                print("==================")
                print()
            }
        }
    }

} catch {
    print(error)
}
