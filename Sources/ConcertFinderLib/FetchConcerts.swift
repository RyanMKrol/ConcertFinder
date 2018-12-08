//
//  FetchConcerts.swift
//  ConcertFinder
//
//  Created by Ryan Krol on 03/12/2018.
//
//  TV: Ashes To Ashes - Season 2 - Episode 1

import Foundation

public class FetchConcertInformation {

    // API Details
    //  - https://www.songkick.com/developer/upcoming-events-for-artist

    private static let apiKey = "vrAL414VWdsFSOMD"
    private static let expectedResponseStatue = "ok"

    /**
     Retrieves upcoming concert information for an artist

     - Parameter city: The city we want to find concerts in
     - Parameter artists: The artists we're finding information for
     - returns: A dictionary of artists and their upcoming events
     */
    public static func getArtistsConertInformation(
        city: String,
        artists: [Artist]
    ) throws -> [String:[Event]] {

        var artistEvents: [String:[Event]] = [:]

        for artist in artists {
            var results: [Event] = []
            let concertInfo = try getConcerts(artistId: artist.getId(), results: &results)

            let filteredConcertInfo = concertInfo.filter { (concert) -> Bool in
                let finished = concert.isFinished()
                let validStatus = concert.isValidStatus()
                let eventCity = concert.getLocation()

                let regex = try? NSRegularExpression(
                    pattern: ".*\(city).*",
                    options: .caseInsensitive
                )
                let matches = regex?.numberOfMatches(
                    in: eventCity,
                    options: [],
                    range: NSRange(location: 0, length: eventCity.count)
                ) ?? 0

                return !finished && validStatus && matches > 0
            }

            artistEvents[artist.getName()] = filteredConcertInfo
        }

        return artistEvents
    }

    /**
     Retrieves upcoming concert information for an artist

     - Parameter artistId: The artists we're finding information for
     - Parameter pageNum: The page number of the API response we're looking at
     - Parameter results: The accumulator to store our results between API calls
     - returns: An array of events for the given artist
     - note: We're using Tail-Recursion in the hope that the compiler optimises
     our function stacks for us
     */
    private static func getConcerts(
        artistId: Int,
        pageNum: Int = 1,
        results: inout [Event]
    ) throws -> [Event] {
        let url = "https://api.songkick.com/api/3.0/artists/\(artistId)/calendar.json?apikey=\(apiKey)&page=\(pageNum)"

        let concertInfo = try ServiceWrapper.callService(
            urlString: url,
            responseType: FetchConcertInformationResponse.self
        )

        guard concertInfo.isValidStatus() else {
            throw SongKickResponseError.StatusNotOK(
                response: concertInfo.getStatus()
            )
        }

        results.append(contentsOf: concertInfo.getEvents())

        if concertInfo.getRemainingPages() > 0 {
            let nextPage = concertInfo.getPageNumber() + 1
            return try getConcerts(
                artistId:artistId,
                pageNum: nextPage,
                results: &results
            )
        }

        return results
    }
}

