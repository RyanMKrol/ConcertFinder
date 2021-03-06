//
//  FetchArtists.swift
//  ConcertFinder
//
//  Created by Ryan Krol on 03/12/2018.
//
//  TV: Life On Mars - Season 2 - Episode 8

import Foundation

import class SwiftToolbox.APIDataHandler
import class SwiftToolbox.InteractionHandler

public class FetchArtists {

    // API Details
    //  - https://www.last.fm/api/show/user.getTopArtists

    enum APIError: Error {
        case CouldNotBuildURL
        case CouldNotGetData
    }

    private static let apiKey = "deaf44dd2b81aa5bae31374e60ebd91c"
    private static let resultLimit = 350

    /**
     Gets the top artists across for the user, across a range of listening periods

     - Parameter username: The user to check the top artists for
     - Parameter listeningThresholds: The thresholds we'll use for a given user

     - returns: A set of artists that have been listened to enough times to fulfil the criteria
     - throws: When we fail to get the artist data
     */
    public static func getFinishedArtistList(
        username: String,
        listeningThresholds: [String:Int]
    ) throws -> Set<String> {

        var artists: Set<String> = Set<String>()

        for threshold in listeningThresholds {
            let newArtists = try getFilteredArtists(
                username: username,
                minPlaysThreshold: threshold.value,
                listeningPeriod: threshold.key
            )

            artists = artists.union(newArtists)
        }

        return artists
    }

    /**
     Grabs the artists filtered by the number of song plays

     - Parameter username: The user to check the top artists for
     - Parameter minPlaysThreshold: The threshold, above which artists should be included in the reuslt
     - Parameter listeningPeriod: The time period to check the top artists for

     - returns: A set of artists that fit the criteria of song plays
     - throws: When we fail to get the artist data
     */
    private static func getFilteredArtists(
        username: String,
        minPlaysThreshold: Int,
        listeningPeriod: String
    ) throws -> Set<String> {

        let url = "http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=\(username)&api_key=\(apiKey)&format=json&period=\(listeningPeriod)&limit=\(resultLimit)"

        let topArtists = try InteractionHandler.fetch(
            dataHandler: APIDataHandler<GetTopArtistsResponse>(url: URL(string: url)!)
        )

        let validArtistNames = try topArtists.getArtists().filter({ (artist) -> Bool in
            return try artist.getPlayCount() > minPlaysThreshold
        }).map({$0.getName()})

        return Set(validArtistNames)
    }
}
