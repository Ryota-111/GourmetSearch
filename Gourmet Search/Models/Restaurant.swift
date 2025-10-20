//
//  Restaurant.swift
//  Gourmet Search
//
//  Created by Ryota Fujitsuka on 2025/10/17.
//

import Foundation

// MARK: - Hot Pepper API Response
struct HotPepperResponse: Codable {
    let results: Results
}

struct Results: Codable {
    let shop: [Restaurant]
    let resultsAvailable: Int
    let resultsReturned: String
    let resultsStart: Int

    enum CodingKeys: String, CodingKey {
        case shop
        case resultsAvailable = "results_available"
        case resultsReturned = "results_returned"
        case resultsStart = "results_start"
    }
}

// MARK: - Restaurant Model
struct Restaurant: Codable, Identifiable {
    let id: String
    let name: String
    let address: String
    let access: String
    let open: String
    let close: String
    let budget: Budget?
    let genre: Genre
    let photo: Photo
    let urls: Urls
    let lat: Double
    let lng: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case access
        case open
        case close
        case budget
        case genre
        case photo
        case urls
        case lat
        case lng
    }
}

// MARK: - Budget
struct Budget: Codable {
    let average: String?
    let name: String
}

// MARK: - Genre
struct Genre: Codable {
    let name: String
    let code: String
}

// MARK: - Photo
struct Photo: Codable {
    let pc: PhotoDetail
    let mobile: PhotoDetail
}

struct PhotoDetail: Codable {
    let l: String
    let m: String?
    let s: String
}

// MARK: - URLs
struct Urls: Codable {
    let pc: String
}
