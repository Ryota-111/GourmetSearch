//
//  SearchParameters.swift
//  Gourmet Search
//
//  Created by Ryota Fujitsuka on 2025/10/17.
//

import Foundation
import CoreLocation

// MARK: - Search Parameters
struct SearchParameters {
    var latitude: Double
    var longitude: Double
    var range: SearchRange
    var keyword: String = ""
    var genre: String = ""

    init(latitude: Double = 0, longitude: Double = 0, range: SearchRange = .m500) {
        self.latitude = latitude
        self.longitude = longitude
        self.range = range
    }
}

// MARK: - Search Range Enum
enum SearchRange: Int, CaseIterable, Identifiable {
    case m500 = 1
    case m1000 = 2
    case m3000 = 3
    case m5000 = 4
    case m10000 = 5

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .m500: return "500"
        case .m1000: return "1km"
        case .m3000: return "3km"
        case .m5000: return "5km"
        case .m10000: return "10km"
        }
    }

    var description: String {
        switch self {
        case .m500: return "500m"
        case .m1000: return "1km"
        case .m3000: return "3km"
        case .m5000: return "5km"
        case .m10000: return "10km"
        }
    }
    
    var meters: Double {
        switch self {
        case .m500: return 500
        case .m1000: return 1000
        case .m3000: return 3000
        case .m5000: return 5000
        case .m10000: return 10000
        }
    }
}

