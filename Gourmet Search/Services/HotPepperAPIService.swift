//
//  HotPepperAPIService.swift
//  Gourmet Search
//
//  Created by Ryota Fujitsuka on 2025/10/17.
//

import Foundation

// MARK: - API Service
class HotPepperAPIService {
    static let shared = HotPepperAPIService()
    
    private let apiKey = "36be9b2ce9abf822"
    private let baseURL = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
    
    private init() {}

    // MARK: - Search Restaurants
    func searchRestaurants(
        parameters: SearchParameters,
        start: Int = 1,
        count: Int = 20
    ) async throws -> (restaurants: [Restaurant], totalCount: Int) {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "lat", value: String(parameters.latitude)),
            URLQueryItem(name: "lng", value: String(parameters.longitude)),
            URLQueryItem(name: "range", value: String(parameters.range.rawValue)),
            URLQueryItem(name: "start", value: String(start)),
            URLQueryItem(name: "count", value: String(count)),
            URLQueryItem(name: "format", value: "json")
        ]

        if !parameters.keyword.isEmpty {
            components?.queryItems?.append(URLQueryItem(name: "keyword", value: parameters.keyword))
        }

        if !parameters.genre.isEmpty {
            components?.queryItems?.append(URLQueryItem(name: "genre", value: parameters.genre))
        }

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(HotPepperResponse.self, from: data)
            return (apiResponse.results.shop, apiResponse.results.resultsAvailable)
        } catch {
            print("Decoding error: \(error)")
            throw APIError.decodingError(error)
        }
    }
}

// MARK: - API Error
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "無効なURL"
        case .invalidResponse:
            return "サーバーからの応答が無効"
        case .decodingError(let error):
            return "データ解析に失敗: \(error.localizedDescription)"
        }
    }
}
