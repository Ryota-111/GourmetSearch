//
//  RestaurantDetailView.swift
//  Gourmet Search
//
//  Created by Ryota Fujitsuka on 2025/10/17.
//

import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    @State private var region: MKCoordinateRegion

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: restaurant.lat,
                longitude: restaurant.lng
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    // MARK: - body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                mainImageSection

                VStack(alignment: .leading, spacing: 20) {
                    restaurantNameSection

                    Divider()

                    genreBudgetSection

                    Divider()

                    addressSection

                    Divider()

                    accessSection

                    Divider()

                    businessHoursSection

                    Divider()

                    mapSection

                    Divider()

                    actionButtonsSection
                }
                .padding()
            }
        }
        .navigationTitle("店舗詳細")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Main Image Section
    private var mainImageSection: some View {
        AsyncImage(url: URL(string: restaurant.photo.pc.l)) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 250)
                    .overlay(ProgressView())
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
            case .failure:
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 250)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
            @unknown default:
                EmptyView()
            }
        }
    }

    // MARK: - Restaurant Name Section
    private var restaurantNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(restaurant.name)
                .font(.title2)
                .fontWeight(.bold)
        }
    }

    // MARK: - Genre and Budget Section
    private var genreBudgetSection: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Label("ジャンル", systemImage: "tag.fill")
                    .font(.caption)
                    .foregroundColor(.myOrange)
                Text(restaurant.genre.name)
                    .font(.body)
            }

            if let budget = restaurant.budget, let average = budget.average, !average.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Label("予算", systemImage: "yensign.circle")
                        .font(.caption)
                        .foregroundColor(.green)
                    Text(average)
                        .font(.body)
                }
            }
        }
    }

    // MARK: - Address Section
    private var addressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("住所", systemImage: "mappin.and.ellipse")
                .font(.headline)
                .foregroundColor(.myOrange)

            Text(restaurant.address)
                .font(.body)
        }
    }

    // MARK: - Access Section
    private var accessSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("アクセス", systemImage: "train.side.front.car")
                .font(.headline)
                .foregroundColor(.myOrange)

            Text(restaurant.access)
                .font(.body)
        }
    }

    // MARK: - Business Hours Section
    private var businessHoursSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("営業時間", systemImage: "clock.fill")
                .font(.headline)
                .foregroundColor(.myOrange)

            VStack(alignment: .leading, spacing: 4) {
                if !restaurant.open.isEmpty {
                    HStack {
                        Text("営業:")
                            .fontWeight(.medium)
                        Text(restaurant.open)
                    }
                    .font(.body)
                }

                if !restaurant.close.isEmpty {
                    HStack {
                        Text("定休日:")
                            .fontWeight(.medium)
                        Text(restaurant.close)
                    }
                    .font(.body)
                }
            }
        }
    }

    // MARK: - Map Section
    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("地図", systemImage: "map.fill")
                .font(.headline)
                .foregroundColor(.myOrange)

            Map(initialPosition: .region(region)) {
                Marker(restaurant.name, coordinate: CLLocationCoordinate2D(
                    latitude: restaurant.lat,
                    longitude: restaurant.lng
                ))
            }
            .frame(height: 200)
            .cornerRadius(12)
        }
    }

    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            Button(action: openInMaps) {
                HStack {
                    Image(systemName: "map.fill")
                    Text("マップで開く")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .orangeSecondaryButton()
            }

            if let url = URL(string: restaurant.urls.pc) {
                Link(destination: url) {
                    HStack {
                        Image(systemName: "safari")
                        Text("ホットペッパーで見る")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .orangePrimaryButton()
                }
            }

            ShareLink(item: restaurant.urls.pc) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("共有")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .orangeSecondaryButton()
            }
        }
        .padding(.bottom, 20)
    }

    // MARK: - Open in Maps
    private func openInMaps() {
        let coordinate = CLLocationCoordinate2D(
            latitude: restaurant.lat,
            longitude: restaurant.lng
        )

        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        let mapItem = MKMapItem(location: location, address: nil)
        mapItem.name = restaurant.name
        mapItem.openInMaps(launchOptions: nil)
    }

}

// MARK: - Preview
#Preview {
    NavigationStack {
        RestaurantDetailView(restaurant: Restaurant(
            id: "1",
            name: "レストラン",
            address: "大阪府",
            access: "大阪駅徒歩5分",
            open: "12:00～21:00",
            close: "無休",
            budget: Budget(average: "3000円", name: "3000円"),
            genre: Genre(name: "お寿司", code: "G001"),
            photo: Photo(
                pc: PhotoDetail(l: "", m: "", s: ""),
                mobile: PhotoDetail(l: "", m: "", s: "")
            ),
            urls: Urls(pc: "https://www.hotpepper.jp"),
            lat: 34.703,
            lng: 135.496
        ))
    }
}
