//
//  URLViewController.swift
//  NewsFeedApp
//
//  Created by Эльдар Адельшин on 29.06.2021.
//

import UIKit
import WebKit

final class URLViewController: UIViewController {
    
    let webView = WKWebView()
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}
