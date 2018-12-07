//
//  FetchArtistInformation.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 07/12/2018.
//
//  TV - Ashes To Ashes - Season 1 - Episode 7

import Foundation
import SwiftyJSON

public class FetchArtistInformation {

    // API Details
    //  - https://www.songkick.com/developer/artist-search

    private static let apiKey = "vrAL414VWdsFSOMD"

    /**
     Retrieves information about an artist

     - Parameter artistNames: The names of the artists
     - returns: An array of artists, including their names and IDs
     */
    public static func getArtistIds(artistNames: Set<String>) throws -> [Artist] {

        return []

    }
}
