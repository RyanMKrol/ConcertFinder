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
    //  - https://www.last.fm/api/show/user.getTopTracks

    enum APITimePeriod: String {
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
    private static let limit = 1000

    private static let period = APITimePeriod.TwelveMonth.rawValue

    public static func getYearlyTopArtists() {
        do {
            try apiWrapper(timePeriod: APITimePeriod.TwelveMonth.rawValue)
        } catch {
            print(error)
        }
    }

    private static func apiWrapper(timePeriod: String) throws {
        let waitTask = DispatchSemaphore(value: 0)
        var resultString: JSON? = nil
        var error: Error? = nil

        getTopArtists(period: timePeriod) { (result: Result) in
            switch result {
            case .success(let result):
                resultString = result
            case .failure(let literalError):
                print("in here")
                error = literalError
            }
            waitTask.signal()
        }

        // Have to wait outside of the API call or a race condition occurs
        waitTask.wait()

        if let error = error {
            throw error
        }

    }

    private static func getTopArtists(period: String, completion: @escaping (Result<JSON>) -> Void) {

        let username = "somethingmeaty"
        let apiString = "http://ws.audioscrobbler.com/2.0/?method=user.gettoptracks&user=\(username)&api_key=\(apiKey)&format=json&type=\(period)"

        guard let url = URL(string: apiString) else {
            return completion(.failure(APIError.CouldNotBuildURL))
        }

        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            completion(Result {
                guard let data = data else {
                    throw APIError.CouldNotGetData
                }
                return try JSON(data: data)
            })
        }.resume()

    }

}
