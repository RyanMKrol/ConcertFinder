//
//  main.swift
//  ConcertFinder
//
//  Created by Ryan Krol on 03/12/2018.
//

import Foundation
import ConcertFinderLib

do {
    let artists = try FetchArtists.getFinishedArtistList(username: "somethingmeaty")
} catch {
    
}
