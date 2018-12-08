//
//  Result.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 04/12/2018.
//
//  TV: It's Always Sunny in Philadelphia - Season 10 - Episode 6

import Foundation

public enum Result<T> {
    case success(T), failure(Error)
}

extension Result {

    // Construct a .Success if the expression returns a value or a .Failure if it throws
    init(throwingExpr: () throws -> T) {
        do {
            let value = try throwingExpr()
            self = Result.success(value)
        } catch {
            self = Result.failure(error)
        }
    }
}
