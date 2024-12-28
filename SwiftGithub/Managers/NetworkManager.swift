//
//  NetworkManager.swift
//  SwiftGithub
//
//  Created by Sultan on 26/12/24.
//

import Foundation

class NetworkManager {
    private init() {}

    static let shared = NetworkManager()
    let baseUrl = "https://api.github.com"

    let imageCache = NSCache<NSString, ImageData>()

    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseUrl + "/users/\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else { throw SGError(.invalidUsername) }

        // Firing api call
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw SGError(.invalidResponse) }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let followers = try decoder.decode([Follower].self, from: data)
                return followers
            }
            catch {
                throw SGError(.invalidData)
            }
        }

        /// we are catching any SGError errors thrown from inner blocks as the outer most "do catch" will catch them
        catch let error as SGError {
            throw error
        }
        catch {
            throw SGError(.unableToComplete)
        }
    }

    func getImageData(from urlString: String) async throws -> Data {
        if let imageData = imageCache.object(forKey: NSString(string: urlString)) {
            print("accessing image from cache")
            return imageData.data
        }

        guard let url = URL(string: urlString) else { throw SGError(.invalidUsername) }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw SGError(.invalidResponse) }

            imageCache.setObject(ImageData(data: data), forKey: NSString(string: urlString))
            return data
        }
        catch let error as SGError {
            throw error
        }
        catch {
            throw SGError(.unableToComplete)
        }
    }
}

class ImageData {
    let data: Data

    init(data: Data) {
        self.data = data
    }
}
