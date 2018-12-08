//
//  FetchConcertInformationResponse.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 07/12/2018.
//
//  TV: Ashes To Ashes - Season 2 - Episode 1

import Foundation

struct FetchConcertInformationResponse: Decodable {

    private let resultsPage: ResultsPage

    /**
     Gets whether the status is valid

     - returns: whether the status is valid
     */
    func isValidStatus() -> Bool {
        return self.resultsPage.status == SongKickAPIConstants.expectedResponseStatus
    }

    /**
     Get the status of the response

     - returns: the response status
     */
    func getStatus() -> String {
        return self.resultsPage.status
    }

    /**
     Gets the concerts for an artist

     - returns: the concerts
     */
    func getEvents() -> [Event] {
        return self.resultsPage.results.events ?? []
    }

    /**
     Gets the number of pages left to expand

     - returns: the remaning pages
     */
    func getRemainingPages() -> Int {
        let perPage = Float(self.resultsPage.perPage)
        let totalEntries = Float(self.resultsPage.totalEntries)

        let numPages = (totalEntries/perPage).rounded(.up)

        return Int(numPages) - self.resultsPage.page
    }

    /**
     Gets the current page number

     - returns: the page number
     */
    func getPageNumber() -> Int {
        return self.resultsPage.page
    }
}

private struct ResultsPage: Decodable {
    let status: String
    let results: Events
    let page: Int
    let perPage: Int
    let totalEntries: Int
}

private struct Events: Decodable {
    enum CodingKeys: String, CodingKey {
        case events = "event"
    }

    let events: [Event]?
}

public struct Event: Decodable {
    enum CodingKeys: String, CodingKey {
        case url = "uri"
        case status = "status"
        case flaggedAsEnded = "flaggedAsEnded"
        case location = "location"
        case date = "start"
    }

    private let url: String
    private let status: String
    private let flaggedAsEnded: Bool?
    private let location: EventLocation
    private let date: EventDate

    /**
     Gets URL associated with the event

     - returns: The event URL
     */
    public func getUrl() -> String {
        return self.url
    }

    /**
     Gets the location associated with the event

     - returns: The city the event will be taking place in
     */
    public func getLocation() -> String {
        return self.location.city
    }

    /**
     Gets the date associated with the event

     - returns: The date of the event
     */
    public func getDate() -> String {
        return "\(self.date.date) - \(self.date.time ?? "")"
    }

    /**
     Returns whether the status of the event is valid

     - returns: If the event status is valid
     */
    public func isValidStatus() -> Bool {
        return self.status == SongKickAPIConstants.expectedResponseStatus
    }

    /**
     Returns whether the event is finished

     - returns: If the event is finished
     */
    public func isFinished() -> Bool {
        return self.flaggedAsEnded ?? false
    }
}


private struct EventLocation: Decodable {
    let city: String
}

private struct EventDate: Decodable {
    let date: String
    let time: String?
}
