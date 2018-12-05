//
//  GetTopArtistsResponse.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 04/12/2018.
//
//  TV - Ashes To Ashes - Season 1 - Episode 2

import Foundation
import SwiftyJSON

enum ResponseError: Error {
    case NoRank
    case NoTotalArtists
    case NoPlayCount
}

public struct GetTopArtistsResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case topArtists = "topartists"
    }

    private let topArtists: TopArtists

    func getArtists() -> [ArtistInfo] {
        return topArtists.artists
    }

    func getResponseAttributes() -> ResponseAttributes {
        return topArtists.attributes
    }

}

struct ResponseAttributes: Decodable {

    enum CodingKeys: String, CodingKey {
        case totalArtists = "total"
    }

    private let totalArtists: String

    func getTotalArtists() throws -> Int {
        guard let totalArtists = Int(totalArtists) else {
            throw ResponseError.NoTotalArtists
        }

        return totalArtists
    }
}

struct TopArtists: Decodable {

    enum CodingKeys: String, CodingKey {
        case artists = "artist"
        case attributes = "@attr"
    }

    let artists: [ArtistInfo]
    let attributes: ResponseAttributes
}

struct ArtistInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case playCount = "playcount"
        case name = "name"
        case attributes = "@attr"
    }

    private let name: String
    private let playCount: String
    private let attributes: JSON

    func getRank() throws -> Int {
        guard let rankString = attributes["rank"].string, let rank = Int(rankString) else {
            throw ResponseError.NoRank
        }

        return rank
    }

    func getPlayCount() throws -> Int {
        guard let playCountInt = Int(playCount) else {
            throw ResponseError.NoPlayCount
        }

        return playCountInt
    }

    func getName() -> String {
        return name
    }
}
