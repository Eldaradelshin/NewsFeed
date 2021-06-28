//
//  DataResponseError.swift
//  NewsFeedApp
//
//  Created by Эльдар Адельшин on 28.06.2021.
//

import Foundation

enum DataResponseError: Error {
    case forbidden
    case notFound
    case unexpected
    case network
    case parsing
    
    var reason: String {
        switch self {
        case .forbidden:
            return "Error 403 - No access"
        case .notFound:
            return "Error 404 - Not found"
        case .unexpected:
            return "Unexpected error"
        case .network:
            return "Network error"
        case .parsing:
            return "Error in retrieving JSON"
        }
    }
}
