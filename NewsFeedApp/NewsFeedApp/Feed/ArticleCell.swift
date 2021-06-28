//
//  ArticleCell.swift
//  NewsFeedApp
//
//  Created by Эльдар Адельшин on 28.06.2021.
//

import UIKit

final class ArticleCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = String(describing: ArticleCell.self)
    
    private var viewModel: FeedViewModel!
    private var ID: Int!
        
    // MARK: - Subviews
    
    private let containerWithShadow: ShadowWithRoundCornersView = {
        let view = ShadowWithRoundCornersView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
        view.backgroundColor = UIColor.white
        view.shadowColor = UIColor.black.cgColor
        view.shadowOpacity = 1
        view.shadowRadius = 8
        view.shadowOffset = CGSize(width: 0, height: 2)
        view.containerView.backgroundColor = .white
        
        return view
    }()
    
    private let articleImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        return button
    } ()

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    // MARK: - Setup Cell
    
    private func setupCell() {
        contentView.backgroundColor = UIColor.lightGray
        addSubViews()
        setupLayout()
        setupButtonAction()
        
        selectionStyle = .none
    }
    
    private func setupButtonAction() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        viewModel.removeArticle(id: ID)
    }
    
    private func addSubViews() {
        contentView.addSubview(containerWithShadow)
        containerWithShadow.containerView.addSubview(articleImage)
        containerWithShadow.containerView.addSubview(titleLabel)
        containerWithShadow.containerView.addSubview(sourceLabel)
        containerWithShadow.containerView.addSubview(dateLabel)
        containerWithShadow.containerView.addSubview(closeButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerWithShadow.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerWithShadow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            containerWithShadow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerWithShadow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            articleImage.topAnchor.constraint(equalTo: containerWithShadow.topAnchor),
            articleImage.leadingAnchor.constraint(equalTo: containerWithShadow.leadingAnchor),
            articleImage.trailingAnchor.constraint(equalTo: containerWithShadow.trailingAnchor),
            articleImage.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: containerWithShadow.containerView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: containerWithShadow.containerView.trailingAnchor, constant: -12),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: articleImage.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerWithShadow.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerWithShadow.trailingAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            sourceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            sourceLabel.leadingAnchor.constraint(equalTo: containerWithShadow.leadingAnchor, constant: 12),
            sourceLabel.trailingAnchor.constraint(equalTo: containerWithShadow.trailingAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: containerWithShadow.leadingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: containerWithShadow.trailingAnchor, constant: -12),
            dateLabel.bottomAnchor.constraint(equalTo: containerWithShadow.containerView.bottomAnchor, constant: -16)
        ])
        
    }
    
    // Configure
    
    func configure(with article: Article, viewModel: FeedViewModel) {
        
        self.viewModel = viewModel
        self.ID = article.id
        
        titleLabel.text = article.title
        sourceLabel.text = article.newsSite
        articleImage.imageFromServerURL(article.imageUrl,
                                        placeHolder: UIImage(named: "placeholder"))
        dateLabel.text = convertDateString(article.publishedAt)
    }
    
    private func convertDateString(_ serverTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date =  dateFormatter.date(from: serverTime)
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        guard let unwrappedDate = date else { return "" }
        return dateFormatter.string(from: unwrappedDate)
    }
}
