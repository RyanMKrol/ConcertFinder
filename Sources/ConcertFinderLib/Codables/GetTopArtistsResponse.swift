//
//  GetTopArtistsResponse.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 04/12/2018.
//
//  TV: Ashes To Ashes - Season 1 - Episode 2

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

    /**
     Get the response artists

     - returns: response artists
     */
    func getArtists() -> [ArtistInfo] {
        return topArtists.artists
    }

    /**
     Get the response attributes

     - returns: response attributes
     */
    func getResponseAttributes() -> ResponseAttributes {
        return topArtists.attributes
    }

}

struct ResponseAttributes: Decodable {

    enum CodingKeys: String, CodingKey {
        case totalArtists = "total"
    }

    private let totalArtists: String

    /**
     Get the total number of artists in the response

     - returns: The number of artists
     - throws: When the number of artists can't be parsed
     */
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

    /**
     Getter for the rank for a given artist

     - returns: The rank for a given artist
     - throws: When the rank cannot be parsed
     */
    func getRank() throws -> Int {
        guard let rankString = attributes["rank"].string, let rank = Int(rankString) else {
            throw ResponseError.NoRank
        }

        return rank
    }

    /**
     Getter for the play count for a given artist

     - returns: The play count for a given artist
     - throws: When the play count cannot be parsed
     */
    func getPlayCount() throws -> Int {
        guard let playCountInt = Int(playCount) else {
            throw ResponseError.NoPlayCount
        }

        return playCountInt
    }

    /**
     Getter for the name of a given artist

     - returns: The name of a given artist
     */
    func getName() -> String {
        return name
    }
}
