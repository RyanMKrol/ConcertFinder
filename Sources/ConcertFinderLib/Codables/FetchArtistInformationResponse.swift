//
//  GetArtistInformationResponse.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 07/12/2018.
//
//  TV - Ashes To Ashes - Season 1 - Episode 8

import Foundation

struct FetchArtistInformationResponse: Decodable {

    enum SongKickError: Error {
        case StatusNotOK(response: String)
    }

    enum CodingKeys: String, CodingKey {
        case results = "resultsPage"
    }

    private let results: ResultsInfo

    /**
     Get the status of the response

     - returns: the response status
     */
    func getStatus() -> String {
        return self.results.status
    }

    /**
     Get the ID of the first artist in the response

     - returns: the arist's ID
     */
    func getId() -> Int {
        return self.results.results.artists[0].id
    }
}

private struct ResultsInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case status = "status"
    }

    let results: SongKickArtists
    let status: String
}

private struct SongKickArtists: Decodable {
    enum CodingKeys: String, CodingKey {
        case artists = "artist"
    }

    let artists: [SongKickArtist]
}

private struct SongKickArtist: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
    }

    let id: Int
}
