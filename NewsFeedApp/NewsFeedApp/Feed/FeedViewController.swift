//
//  ViewController.swift
//  NewsFeedApp
//
//  Created by Эльдар Адельшин on 27.06.2021.
//

import UIKit

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        let network = NetworkService()
        network.fetchArticles(with: .defaultRequest(), offset: 0, completion: { result in
            switch result {
            case let .success(articles):
                print(articles)
            case let .failure(error):
                print(error.reason)
            }
        })
    }


}

