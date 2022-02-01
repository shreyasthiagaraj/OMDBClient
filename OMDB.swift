//
//  OMBDClient.swift
//  Fast AF - OMDBclient
//

import Foundation

public final class OMDBClient {

    public static var shared = OMDBClient()

    /// The API Key provided for your user ID.
    public var apiKey: String?

    /// Retrieve movies from OMBD that match the given search text.
    /// - parameter searchText: The filter text to search by.
    /// - parameter page: The page number of results to retrieve, defaulted to 1.
    /// - parameter completion: Callback with an `OMDBResult` object containing movie results on success or an error.
    public func fetchMovies(searchText: String, page: Int = 1, completion: @escaping (OMDBResult) -> ()) {
        guard let key = apiKey else {
            completion(.error)
            return
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "omdbapi.com"
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: key),
            URLQueryItem(name: "s", value: searchText),
            URLQueryItem(name: "page", value: page.description)
        ]
        let url = urlComponents.url!
        // Fetch movie results
        self.urlSession.dataTask(
            with: url,
            completionHandler: { data, response, error in
                guard error == nil, let data = data else {
                    completion(.error)
                    return
                }
                guard let searchResults = try? JSONDecoder().decode(SearchResults.self, from: data) else {
                    completion(.success(movies: [], totalResults: 0))
                    return
                }
                completion(
                    .success(
                        movies: searchResults.search,
                        totalResults: Int(searchResults.totalResults) ?? searchResults.search.count
                    )
                )
        }).resume()
    }

    private let urlSession = URLSession(configuration: .default)
}

/// The resuls of an OMDB API request.
public enum OMDBResult {
    /// The result for an unsuccessful API request for any reason (invalid API key, no connection, etc.)
    case error

    /// The result for  a successful API request.
    /// - parameter movies: The list of movies retrieved from OMDB for the current page.
    /// - parameter totalResults: The total number of results for the given search term.
    case success(movies: [Movie], totalResults: Int)
}

public struct Movie: Hashable, Codable {
    public var title: String
    public var year: String
    public var imdbID: String
    public var type: String
    public var poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}

struct SearchResults: Hashable, Codable {
    var search: [Movie]
    var totalResults: String
    var response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }
}
