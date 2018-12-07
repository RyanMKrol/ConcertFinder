//
//  Artist.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 07/12/2018.
//
//  TV - Ashes To Ashes - Season 1 - Episode 7

import Foundation

public class Artist {

    enum ArtistError: Error {
        case NoId
    }

    private let name: String
    private var identifier: String? = nil

    init(name: String) {
        self.name = name
    }

    /**
     Get the artist name

     - returns: The name of the artist
     */
    func getName() -> String {
        return self.name
    }

    /**
     Set the artist ID

     - Parameter period: The identifier of the artist
     - throws: An exception if no ID exists
     */
    func setId(identifier: String) {
        self.identifier = identifier
    }

    /**
     Retrieve the artist ID

     - returns: The ID of an artist
     - throws: An exception if no ID exists
     */
    func getId() throws -> String {
        guard let id = self.identifier else {
            throw ArtistError.NoId
        }

        return id
    }

}
