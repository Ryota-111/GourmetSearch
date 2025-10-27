//
//  SearchResultsView.swift
//  Gourmet Search
//
//  Created by Ryota Fujitsuka on 2025/10/17.
//

import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var viewModel: RestaurantSearchViewModel

    // MARK: - body
    var body: some View {
        ZStack {
            if viewModel.isLoading && viewModel.restaurants.isEmpty {
                ProgressView("検索中...")
            } else if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            } else if viewModel.restaurants.isEmpty {
                emptyView
            } else {
                restaurantList
            }
        }
        .navigationTitle("検索結果")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Restaurant List
    private var restaurantList: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(viewModel.totalCount)件の検索結果")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemGroupedBackground))

            List {
                ForEach(viewModel.restaurants) { restaurant in
                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                        RestaurantView(restaurant: restaurant)
                    }
                }

                if viewModel.canLoadMore {
                    HStack {
                        Spacer()
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        } else {
                            Button(action: {
                                Task {
                                    await viewModel.loadMore()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "arrow.down.circle.fill")
                                    Text("もっと見る")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.orangeButtonGradient)
                                .cornerRadius(25)
                                .shadow(color: Color.myOrange.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .padding(.vertical, 24)
                        }
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
    }

    // MARK: - Error View
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.red)

            Text("エラーが発生しました")
                .font(.headline)

            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("再試行") {
                Task {
                    await viewModel.searchRestaurants()
                }
            }
            .buttonStyle(.bordered)
        }
    }

    // MARK: - Empty View
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("検索結果が見つかりませんでした")
                .font(.headline)

            Text("検索条件を変更してお試しください")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Restaurant View
struct RestaurantView: View {
    let restaurant: Restaurant

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: restaurant.photo.mobile.l)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 80)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .frame(width: 80, height: 80)
                        .background(Color.gray.opacity(0.2))
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 6) {
                Text(restaurant.name)
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(restaurant.access)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                HStack(spacing: 4) {
                    Image(systemName: "tag.fill")
                        .font(.caption)
                        .foregroundColor(.myOrange)
                    Text(restaurant.genre.name)
                        .font(.caption)
                        .foregroundColor(.orange)
                }

                if let budget = restaurant.budget, let average = budget.average, !average.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "yensign.circle")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text(average)
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SearchResultsView(viewModel: RestaurantSearchViewModel())
    }
}
