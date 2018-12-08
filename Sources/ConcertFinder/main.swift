//
//  main.swift
//  ConcertFinder
//
//  Created by Ryan Krol on 03/12/2018.
//

import Foundation
import ConcertFinderLib

private let username = "somethingmeaty"
private let city = "London"

do {
    let artists = try FetchArtists.getFinishedArtistList(username: username)
    let artistInfo = try FetchArtistInformation.getArtistIds(artistNames: artists)
    let artistConcertInfo = try FetchConcertInformation.getArtistsConertInformation(
        city: city,
        artists: artistInfo
    )

    for artistConcerts in artistConcertInfo {
        for event in artistConcerts.value {
            print(event.getLocation())
            print(event.getDate())
            print(event.getUrl())
        }
    }

    print(artistConcertInfo)
} catch {
    print(error)
}
