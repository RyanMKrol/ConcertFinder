//
//  APIWrapper.swift
//  ConcertFinderLib
//
//  Created by Ryan Krol on 07/12/2018.
//
//  TV: Ashes To Ashes - Season 1 - Episode 8

import Foundation

public class ServiceWrapper {

    private enum APIError: Error {
        case CouldNotBuildURL
        case CouldNotGetData
    }

    private init(){}

    /**
     A wrapper for calling an API, will handle data, and exceptions

     - Parameter urlString: The URL of the API you want to call
     - Parameter responseType: The type of the response you're expecting
     - returns: The API response
     - throws: Any exceptions related to calling the API, or parsing the response
     */
    static func callService<T: Decodable>(urlString: String, responseType: T.Type) throws -> T {

        var apiResult: T? = nil
        var error: Error? = nil

        ServiceWrapper.call(urlString: urlString, responseType: T.self) { (result: Result) in
            switch result {
            case .success(let callbackResult):
                apiResult = callbackResult
            case .failure(let callbackError):
                print("There's an issue doing something with this API type: \(responseType)")
                error = callbackError
            }
        }

        if let error = error {
            throw error
        }

        guard let result = apiResult else {
            throw APIError.CouldNotGetData
        }

        return result
    }

    /**
     Uses an established pattern for calling an endpoint, and decoding the response

     - Parameter urlString: The string holding the API URL
     - Parameter responseType: The type of the codable we want to find the response in
     - Parameter completion: The callback to call once the data has been handled (or not)
     */
    private static func call<T: Decodable>(
        urlString: String,
        responseType: T.Type,
        completion: @escaping (Result<T>) -> Void
    ) {
        let waitTask = DispatchSemaphore(value: 0)

        guard let urlString = urlString.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed
        ) else {
            return completion(.failure(APIError.CouldNotBuildURL))
        }

        guard let url = URL(string: urlString) else {
            return completion(.failure(APIError.CouldNotBuildURL))
        }

        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            defer { waitTask.signal() }

            completion(Result {
                guard let data = data else {
                    throw APIError.CouldNotGetData
                }
                return try JSONDecoder().decode(T.self, from: data)
            })
            }.resume()

        waitTask.wait()
    }
}
