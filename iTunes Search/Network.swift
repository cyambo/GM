//
//  Network.swift
//  iTunes Search
//
//  Created by Cristiana Yambo on 3/19/21.
//

import Foundation


class Network {

    /// Sends a request to the iTunes search
    /// - Parameters:
    ///   - term: Term to search for
    ///   - response: response with codable data
    func sendRequest(_ term: String, response:@escaping (ItunesSearch?) -> Void) {
        let sessionConfig = URLSessionConfiguration.default

        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        guard let baseUrl = URL(string: "https://itunes.apple.com/search") else {return}
        let URL = baseUrl.appending("term", value: term).appending("limit", value: "300")
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request, completionHandler: { (results: Data?, urlResponse: URLResponse?, error: Error?) -> Void in
            response(self.getCodable(results))
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }

    /// Converts Data into Codable
    /// - Parameter data: Data from server
    /// - Returns: Codable data
    func getCodable(_ data: Data?) -> ItunesSearch? {
        guard let data = data else { return nil }
        let jsonDecoder = JSONDecoder()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        do {
            return try jsonDecoder.decode(ItunesSearch.self, from: data)
        } catch {
            print(error)
        }
        return nil
    }
}

extension URL {

    func appending(_ queryItem: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
}


