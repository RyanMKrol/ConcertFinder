//
//  FetchConcertsDataHandler.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 22/12/2018.
//
//  TV: Peep Show - Season 4 - Episode 4

import Foundation
import SwiftToolbox

class FetchConcertsDataHandler: APIDataHandler {
    var url: URL
    var result: FetchConcertInformationResponse?

    typealias processedData = FetchConcertInformationResponse

    init(url: URL) {
        self.url = url
    }
}

