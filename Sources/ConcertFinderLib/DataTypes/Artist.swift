//
//  Artist.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 07/12/2018.
//
//  TV: Ashes To Ashes - Season 1 - Episode 7

import Foundation

public class Artist {

    private let name: String
    private let identifier: Int

    init(name: String, identifier: Int) {
        self.name = name
        self.identifier = identifier
    }

    /**
     Get the artist name

     - returns: The name of the artist
     */
    public func getName() -> String {
        return self.name
    }

    /**
     Retrieve the artist ID

     - returns: The ID of an artist
     - throws: An exception if no ID exists
     */
    public func getId() -> Int {
        return self.identifier
    }

}
