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
    private static let expectedResponseStatue = "ok"

    /**
     Retrieves information about an artist

     - Parameter artistNames: The names of the artists
     - returns: An array of artists, including their names and IDs
     */
    public static func getArtistIds(artistNames: Set<String>) throws -> [Artist] {

        let artists = try artistNames.map { (name) -> Artist in
            let url = "https://api.songkick.com/api/3.0/search/artists.json?apikey=\(apiKey)&query=\(name)"
            let artistInfo = try ServiceWrapper.callService(
                urlString: url,
                responseType: FetchArtistInformationResponse.self
            )

            if artistInfo.getStatus() != expectedResponseStatue {
                throw FetchArtistInformationResponse.SongKickError.StatusNotOK(
                    response: artistInfo.getStatus()
                )
            }

            return Artist.init(name: name, identifier: artistInfo.getId())
        }

        return artists
    }
}
