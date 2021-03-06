//
//  FetchArtistInformation.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 07/12/2018.
//
//  TV: Ashes To Ashes - Season 1 - Episode 7

import Foundation

import class SwiftToolbox.APIDataHandler
import class SwiftToolbox.InteractionHandler
import enum SwiftToolbox.CommonErrors

public class FetchArtistInformation {

    // API Details
    //  - https://www.songkick.com/developer/artist-search

    private static let apiKey = "vrAL414VWdsFSOMD"

    /**
     Retrieves information about an artist

     - Parameter artistNames: The names of the artists

     - returns: An array of artists, including their names and IDs
     - throws: An exception if the calls to the API fail
     */
    public static func getArtistIds(artistNames: Set<String>) throws -> [Artist] {

        // Occasionally we can't find the user we want from the API, so we put nil in this list, and
        //  then use compactMap to filter out the missing users
        let artists:[Artist] = try artistNames.map { (name) -> Artist? in

            let rawUrl = "https://api.songkick.com/api/3.0/search/artists.json?apikey=\(apiKey)&query=\(name)"

            guard let url = rawUrl.addingPercentEncoding(
                withAllowedCharacters: CharacterSet.urlQueryAllowed
            ) else {
                throw CommonErrors.CouldNotBuildURL
            }

            let artistInfo = try InteractionHandler.fetch(
                dataHandler: APIDataHandler<FetchArtistInformationResponse>(url: URL(string: url)!)
            )

            guard artistInfo.isValidStatus() else {
                throw SongKickResponseError.StatusNotOK(
                    response: artistInfo.getStatus()
                )
            }

            if let id = artistInfo.getId() {
                return Artist(name: name, identifier: id)
            }

            return nil
        }.compactMap({$0})

        return artists
    }
}
