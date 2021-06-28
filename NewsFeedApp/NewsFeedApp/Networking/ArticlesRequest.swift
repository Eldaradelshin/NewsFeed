//
//  ArticlesRequest.swift
//  NewsFeedApp
//
//  Created by Эльдар Адельшин on 28.06.2021.
//

import Foundation

struct ArticlesRequest {
    var path: String {
        return "articles"
    }
    
    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension ArticlesRequest {
    static func defaultRequest() -> ArticlesRequest {
        let defaultParameters = ["_limit": "20", "_sort": "publishedAt"]
        return ArticlesRequest(parameters: defaultParameters)
    }
}
