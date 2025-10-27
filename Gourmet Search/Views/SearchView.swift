//
//  SearchView.swift
//  Gourmet Search
//
//  Created by Ryota Fujitsuka on 2025/10/17.
//

import SwiftUI
import CoreLocation
import Combine
import MapKit

struct SearchView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = RestaurantSearchViewModel()
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedRange : SearchRange = .m500
    @State private var keyword: String = ""
    @State private var navigateResults = false
    @Environment(\.colorScheme) var colorScheme

    // MARK: - body
    var body: some View {
        NavigationStack {
                VStack(spacing: 10) {
                    header
                    
                    location
                    
                    searchRange
                    
                    keywordSearch
                    
                    Spacer()
                    
                    searchButton
                }
                .padding()
                .navigationTitle("レストラン検索")
                .navigationDestination(isPresented: $navigateResults) {
                    SearchResultsView(viewModel: viewModel)
                }
                .onAppear {
                    locationManager.requestLocationPermission()
                }
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.red, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 65, height: 65)
                    .shadow(color: .orange.opacity(0.3), radius: 12, x: 0, y: 6)

                Image(systemName: "fork.knife")
                    .font(.system(size: 33, weight: .semibold))
                    .foregroundColor(.white)
            }

            Text("近くのレストランを探す")
                .font(.title3.bold())
        }
        .padding()
    }
    
    // MARK: - Location
    private var location: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.orange)
                Text("現在地")
                    .font(.title3.bold())
            }
            
            if let location = locationManager.location {
                VStack(spacing: 8) {
                    Map(position: $cameraPosition) {
                        Marker("現在地", coordinate: location.coordinate)
                        MapCircle(center: location.coordinate, radius: selectedRange.meters)
                            .foregroundStyle(.orange.opacity(0.2))
                            .stroke(.orange, lineWidth: 2)
                    }
                    .mapControls {
                        MapUserLocationButton()
                        MapCompass()
                    }
                    .frame(height: 230)
                    .cornerRadius(12)
                    .onChange(of: location.coordinate.latitude) { _, _ in
                        updateMapCamera(for: location.coordinate)
                    }
                    .onChange(of: selectedRange) { _, _ in
                        updateMapCamera(for: location.coordinate)
                    }
                    .onAppear {
                        cameraPosition = .region(
                           MKCoordinateRegion(
                                center: location.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                           )
                        )
                        updateMapCamera(for: location.coordinate)
                    }
                }
            } else if let errorMessage = locationManager.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
            } else {
                HStack {
                    ProgressView()
                    Text("位置情報を取得しています...")
                        .font(.caption)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Search Range
    private var searchRange: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "map.circle.fill")
                    .foregroundColor(.orange)
                Text("検索範囲")
                    .font(.title3.bold())
            }
            
            Picker("検索半径", selection: $selectedRange) {
                ForEach(SearchRange.allCases) { range in
                    Text(range.description).tag(range)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    // MARK: - Keyword Search
    private var keywordSearch: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.orange)
                Text("キーワード")
                    .font(.title3.bold())
                Text("(任意)")
                    .font(.caption)
            }

            TextField("例: イタリアン、居酒屋", text: $keyword)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
        }
    }
    
    // MARK: - Search Button
    private var searchButton: some View {
        Button (action: performSearch) {
            HStack {
                Image(systemName: "magnifyingglass")
                Text("検索")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .orangePrimaryButton()
            .opacity(locationManager.location != nil ? 1.0 : 0.5)
        }
        .disabled(locationManager.location == nil)
    }
    
    // MARK: - Perform Search
    private func performSearch() {
        guard let location = locationManager.location else { return }

        viewModel.updateLocation(location)
        viewModel.searchParameters.range = selectedRange
        viewModel.searchParameters.keyword = keyword

        Task {
            await viewModel.searchRestaurants()
            navigateResults = true
        }
    }
    
    // MARK: - Update Map Camera
    private func updateMapCamera(for coordinate: CLLocationCoordinate2D) {
        let radiusInMeters = selectedRange.meters
        let spanMultiplier = 2.5
        let metersPerDegree = 111000.0
        let span = (radiusInMeters * spanMultiplier) / metersPerDegree

        cameraPosition = .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: span,
                    longitudeDelta: span
                )
            )
        )
    }
}

// MARK: - Location Annotation
struct LocationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    SearchView()
}
