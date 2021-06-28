//
//  ViewController.swift
//  NewsFeedApp
//
//  Created by Эльдар Адельшин on 27.06.2021.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: FeedViewModel!
    
    // MARK: - Subviews

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .lightGray
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        setupTable()
        
        let request = ArticlesRequest.defaultRequest()
        viewModel = FeedViewModel(request: request, delegate: self)
        
        viewModel.fetchArticles()
        
    }
    
    // MARK: - Table setup
    
    private func setupTable() {
        layoutTable()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshArticles(_:)), for: .valueChanged)
    }
    
    private func layoutTable() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

    // MARK: Refresh control

extension FeedViewController {
    @objc func refreshArticles(_ sender: Any) {
        viewModel.refreshArticles()
    }
}

    // MARK: - UITableViewDataSource, UITableViewDelegate

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseIdentifier) as! ArticleCell
        cell.configure(with: viewModel.article(at: indexPath.row), viewModel: viewModel)
        return cell
    }
}

    // MARK: Prefetch
    
extension FeedViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchArticles()
        }
    }
}

    // MARK: - Delegate

extension FeedViewController: FeedViewModelDelegate {
    func onFetchCompleted() {
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func onFetchFailed(with reason: String) {
        print(reason)
    }
    
    func onArticleDeletion(with index: Int) {
        let indexPaths = [IndexPath(row: index, section: 0)]
        tableView.beginUpdates()
        tableView.deleteRows(at: indexPaths, with: .fade)
        tableView.endUpdates()
    }
}

    // MARK: - Helpers

private extension FeedViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.totalCount - 1
    }
}

