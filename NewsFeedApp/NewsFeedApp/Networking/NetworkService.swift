//
//  NetworkService.swift
//  NewsFeedApp
//
//  Created by Эльдар Адельшин on 28.06.2021.
//

import Foundation

final class NetworkService {
    private lazy var baseURL: URL = {
        return URL(string: "https://api.spaceflightnewsapi.net/v3/")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
   public func fetchArticles(with request: ArticlesRequest,
                       offset: Int = 0,
                       completion: @escaping (Result<[Article], DataResponseError>) -> Void) {
        
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        
        let parameters = ["_start": "\(offset)"].merging(request.parameters, uniquingKeysWith: +)
        
        let encodedUrlRequest = urlRequest.encode(with: parameters)
        
        session.dataTask(
            with: encodedUrlRequest,
            completionHandler: { data, response, error in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.hasSuccessStatusCode,
                    let data = data
                else {
                    completion(Result.failure(DataResponseError.unexpected))
                    return
                }

                guard let decodedResponse = try? JSONDecoder().decode([Article].self, from: data)
                else {
                    completion(Result.failure(DataResponseError.parsing))
                    return
                }
                
                completion(Result.success(decodedResponse))
            }).resume()
    }
}

