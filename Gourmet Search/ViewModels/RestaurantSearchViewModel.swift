//
//  RestaurantSearchViewModel.swift
//  Gourmet Search
//
//  Created by Ryota Fujitsuka on 2025/10/17.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

// MARK: - Restaurant Search ViewModel
@MainActor
class RestaurantSearchViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var searchParameters = SearchParameters()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var totalCount: Int = 0
    @Published var currentPage: Int = 1

    private let apiService = HotPepperAPIService.shared
    private let itemsPerPage = 20

    // MARK: - Search Restaurants
    func searchRestaurants(reset: Bool = true) async {
        isLoading = true
        errorMessage = nil

        if reset {
            currentPage = 1
            restaurants = []
        }

        do {
            let start = (currentPage - 1) * itemsPerPage + 1
            let result = try await apiService.searchRestaurants(
                parameters: searchParameters,
                start: start,
                count: itemsPerPage
            )

            if reset {
                restaurants = result.restaurants
            } else {
                restaurants.append(contentsOf: result.restaurants)
            }

            totalCount = result.totalCount
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    // MARK: - Load More (Paging)
    func loadMore() async {
        guard !isLoading else { return }
        guard restaurants.count < totalCount else { return }

        currentPage += 1
        await searchRestaurants(reset: false)
    }

    // MARK: - Update Location
    func updateLocation(_ location: CLLocation) {
        searchParameters.latitude = location.coordinate.latitude
        searchParameters.longitude = location.coordinate.longitude
    }

    // MARK: - Can Load More
    var canLoadMore: Bool {
        restaurants.count < totalCount
    }
}
