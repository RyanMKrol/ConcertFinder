//
//  FetchArtists.swift
//  ConcertFinder
//
//  Created by Ryan Krol on 03/12/2018.
//
//  TV - Life On Mars - Season 2 - Episode 8

import Foundation
import SwiftyJSON

public class FetchArtists {

    // API Details
    //  - https://www.last.fm/api/show/user.getTopArtists

    enum APITimePeriod: String {
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
    private static let resultLimit = 1000

    public static func getFinishedArtistList(username: String) throws -> Set<String> {
        let overallArtists = try getOverallTopArtists(username: username)
        let yearlyArtists = try getYearlyTopArtists(username: username)
        let halfYearlyArtists = try getHalfYearlyTopArtists(username: username)
        let monthlyArtists = try getMonthlyTopArtists(username: username)

        return monthlyArtists.union(halfYearlyArtists).union(yearlyArtists).union(overallArtists)
    }

    public static func getMonthlyTopArtists(username: String) throws -> Set<String> {
        let monthlyMinPlaysEntry = 30
        let period = APITimePeriod.OneMonth.rawValue

        return try getFilteredArtists(
            username: username,
            minPlaysThreshold: monthlyMinPlaysEntry,
            listeningPeriod: period
        )
    }

    public static func getHalfYearlyTopArtists(username: String) throws -> Set<String> {
        let halfYearlyMinPlaysEntry = 50
        let period = APITimePeriod.SixMonth.rawValue

        return try getFilteredArtists(
            username: username,
            minPlaysThreshold: halfYearlyMinPlaysEntry,
            listeningPeriod: period
        )
    }

    public static func getYearlyTopArtists(username: String) throws -> Set<String> {
        let yearlyMinPlaysEntry = 70
        let period = APITimePeriod.TwelveMonth.rawValue

        return try getFilteredArtists(
            username: username,
            minPlaysThreshold: yearlyMinPlaysEntry,
            listeningPeriod: period
        )
    }

    public static func getOverallTopArtists(username: String) throws -> Set<String> {
        let overallMinPlaysEntry = 100
        let period = APITimePeriod.Overall.rawValue

        return try getFilteredArtists(
            username: username,
            minPlaysThreshold: overallMinPlaysEntry,
            listeningPeriod: period
        )
    }

    private static func getFilteredArtists(
        username: String,
        minPlaysThreshold: Int,
        listeningPeriod: String
    ) throws -> Set<String> {
        let topArtists = try apiWrapper(timePeriod: listeningPeriod, username: username)

        let validArtistNames = try topArtists.getArtists().filter({ (artist) -> Bool in
            return try artist.getPlayCount() > minPlaysThreshold
        }).map({$0.getName()})

        return Set(validArtistNames)
    }

    private static func apiWrapper(timePeriod: String, username: String) throws -> GetTopArtistsResponse {
        var apiResult: GetTopArtistsResponse? = nil
        var error: Error? = nil

        getTopArtists(period: timePeriod, username: username) { (result: Result) in
            switch result {
            case .success(let callbackResult):
                apiResult = callbackResult
            case .failure(let callbackError):
                error = callbackError
            }
        }

        if let error = error {
            throw error
        }

        guard let result = apiResult else {
            throw APIError.CouldNotGetData
        }

        return result

    }

    private static func getTopArtists(period: String, username: String, completion: @escaping (Result<GetTopArtistsResponse>) -> Void) {
        let waitTask = DispatchSemaphore(value: 0)
        let apiString = "http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=\(username)&api_key=\(apiKey)&format=json&period=\(period)&limit=\(resultLimit)"

        guard let url = URL(string: apiString) else {
            return completion(.failure(APIError.CouldNotBuildURL))
        }

        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            defer { waitTask.signal() }
            completion(Result {
                guard let data = data else {
                    throw APIError.CouldNotGetData
                }
                return try JSONDecoder().decode(GetTopArtistsResponse.self, from: data)
            })
        }.resume()

        waitTask.wait()
    }

}
