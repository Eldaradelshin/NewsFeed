//
//  FeedViewModel.swift
//  NewsFeedApp
//
//  Created by Эльдар Адельшин on 28.06.2021.
//

import Foundation

protocol FeedViewModelDelegate: class {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
    func onArticleDeletion(with index: Int)
}

final class FeedViewModel {
    
    // MARK: - Delegate
    
    private weak var delegate: FeedViewModelDelegate?
    
    // MARK: - Properties

    private var articles: [Article] = []
    
    private var bannedArticleIDs: [Int] = []
    
    private var total = 0
    private var isFetchInProgress = false

    let networkService = NetworkService()
    let request: ArticlesRequest
    
    // MARK: - Init
    
    init(request: ArticlesRequest, delegate: FeedViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    func article(at index: Int) -> Article {
        return articles[index]
    }
    
    // MARK: - Methods
    
    func removeArticle(id: Int) {
        let index = articles.firstIndex { $0.id == id }
        guard let articleIndex = index else { return }
        articles.remove(at: articleIndex)
        bannedArticleIDs.append(id)
        total -= 1
        delegate?.onArticleDeletion(with: articleIndex)
    }
    
    func refreshArticles() {
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        
        networkService.fetchArticles(with: request) { result in
            switch result {
            case let .success(articles):
                DispatchQueue.main.async { [self] in
                    let availableArticles = articles.filter({ !bannedArticleIDs.contains($0.id) })
                    
                    self.total = availableArticles.count
                    self.isFetchInProgress = false
                    self.articles = availableArticles
                    
                    self.delegate?.onFetchCompleted()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                  self.isFetchInProgress = false
                  self.delegate?.onFetchFailed(with: error.reason)
                }
            }
        }
    }
    
    func fetchArticles() {
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        
        networkService.fetchArticles(with: request, offset: totalCount) { result in
            switch result {
            case let .success(articles):
                DispatchQueue.main.async { [self] in
                    let availableArticles = articles.filter({ !bannedArticleIDs.contains($0.id) })
                    
                    self.total += availableArticles.count
                    self.isFetchInProgress = false
                    self.articles.append(contentsOf: availableArticles)
                    
                    self.delegate?.onFetchCompleted()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                  self.isFetchInProgress = false
                  self.delegate?.onFetchFailed(with: error.reason)
                }
            }
        }
    }
}
