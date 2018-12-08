//
//  FetchArtists.swift
//  ConcertFinder
//
//  Created by Ryan Krol on 03/12/2018.
//
//  TV: Life On Mars - Season 2 - Episode 8

import Foundation

public class FetchArtists {

    // API Details
    //  - https://www.last.fm/api/show/user.getTopArtists

    public enum APITimePeriod: String {
        case Overall = "overall"
        case TwelveMonth = "12month"
        case SixMonth = "6month"
        case ThreeMonth = "3month"
        case OneMonth = "1month"
    }

    enum APIError: Error {
        case CouldNotBuildURL
        case CouldNotGetData
    }

    private static let apiKey = "deaf44dd2b81aa5bae31374e60ebd91c"
    private static let resultLimit = 100

    /**
     Gets the top artists across for the user, across a range of listening periods

     - Parameter username: The user to check the top artists for
     - Parameter listeningThresholds: The thresholds we'll use for a given user
     - returns: A set of artists that have been listened to enough times to fulfil the criteria
     - throws: When we fail to get the artist data
     */
    public static func getFinishedArtistList(
        username: String,
        listeningThresholds: ListeningThresholds
    ) throws -> Set<String> {
        let overallArtists = try getOverallTopArtists(
            username: username,
            threshold: listeningThresholds.overall
        )
        let yearlyArtists = try getYearlyTopArtists(
            username: username,
            threshold: listeningThresholds.oneYear
        )
        let halfYearlyArtists = try getHalfYearlyTopArtists(
            username: username,
            threshold: listeningThresholds.sixMonth
        )
        let monthlyArtists = try getMonthlyTopArtists(
            username: username,
            threshold: listeningThresholds.oneMonth
        )

        return monthlyArtists.union(halfYearlyArtists).union(yearlyArtists).union(overallArtists)
    }

    /**
     Gets the top artists across the user's month year of listening

     - Parameter username: The user to check the top artists for
     - Parameter threshold: The threshold we'll use for a given user
     - returns: A set of artists that have been listened to enough times to fulfil the criteria
     - throws: When we fail to get the artist data
     */
    public static func getMonthlyTopArtists(username: String, threshold: Int) throws -> Set<String> {
        let monthlyMinPlaysEntry = threshold
        let period = APITimePeriod.OneMonth.rawValue

        return try getFilteredArtists(
            username: username,
            minPlaysThreshold: monthlyMinPlaysEntry,
            listeningPeriod: period
        )
    }

    /**
     Gets the top artists across the user's last half-year of listening

     - Parameter username: The user to check the top artists for
     - Parameter threshold: The threshold we'll use for a given user
     - returns: A set of artists that have been listened to enough times to fulfil the criteria
     - throws: When we fail to get the artist data
     */
    public static func getHalfYearlyTopArtists(username: String, threshold: Int) throws -> Set<String> {
        let halfYearlyMinPlaysEntry = threshold
        let period = APITimePeriod.SixMonth.rawValue

        return try getFilteredArtists(
            username: username,
            minPlaysThreshold: halfYearlyMinPlaysEntry,
            listeningPeriod: period
        )
    }

    /**
     Gets the top artists across the user's last year of listening

     - Parameter username: The user to check the top artists for
     - Parameter threshold: The threshold we'll use for a given user
     - returns: A set of artists that have been listened to enough times to fulfil the criteria
     - throws: When we fail to get the artist data
     */
    public static func getYearlyTopArtists(username: String, threshold: Int) throws -> Set<String> {
        let yearlyMinPlaysEntry = threshold
        let period = APITimePeriod.TwelveMonth.rawValue

        return try getFilteredArtists(
            username: username,
            minPlaysThreshold: yearlyMinPlaysEntry,
            listeningPeriod: period
        )
    }

    /**
     Gets the top artists across the user's entire listening history

     - Parameter username: The user to check the top artists for
     - Parameter threshold: The threshold we'll use for a given user
     - returns: A set of artists that have been listened to enough times to fulfil the criteria
     - throws: When we fail to get the artist data
     */
    public static func getOverallTopArtists(username: String, threshold: Int) throws -> Set<String> {
        let overallMinPlaysEntry = threshold
        let period = APITimePeriod.Overall.rawValue

        return try getFilteredArtists(
            username: username,
            minPlaysThreshold: overallMinPlaysEntry,
            listeningPeriod: period
        )
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
        let topArtists = try ServiceWrapper.callService(
            urlString: url,
            responseType: GetTopArtistsResponse.self
        )

        let validArtistNames = try topArtists.getArtists().filter({ (artist) -> Bool in
            return try artist.getPlayCount() > minPlaysThreshold
        }).map({$0.getName()})

        return Set(validArtistNames)
    }
}
