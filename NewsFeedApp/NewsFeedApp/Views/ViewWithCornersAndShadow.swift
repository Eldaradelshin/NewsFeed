//
//  ViewWithCornersAndShadow.swift
//  NewsFeedApp
//
//  Created by Эльдар Адельшин on 28.06.2021.
//

import UIKit
//import SnapKit

public class ShadowWithRoundCornersView: UIView {
    /// Add subviews to the containerView
    public let containerView = UIView()

    // MARK: - Shadow settings, adjustable

    public var shadowColor = Shadows.color
    public var shadowOffset = Shadows.offset
    public var shadowOpacity = Shadows.opacity
    public var shadowRadius = Shadows.smallRadius
    /// By default masks only top corners
    public var maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupConstraints()
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius

        if !maskedCorners.isEmpty {
            containerView.layer.cornerRadius = Corners.topOfPanelSmall
            containerView.layer.masksToBounds = true
            containerView.layer.maskedCorners = maskedCorners
            if #available(iOS 13.0, *) {
                containerView.layer.cornerCurve = .continuous
            }
        }
    }

    private func setupView() {
        addSubview(containerView)
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

private extension ShadowWithRoundCornersView {
    enum Shadows {
        public static let color = UIColor.black.cgColor
        public static let offset = CGSize(width: 0, height: 4)
        public static let opacity: Float = 1
        public static let smallRadius: CGFloat = 8
        public static let mediumRadius: CGFloat = 16.0
    }

    enum Corners {
        static let topOfPanelSmall: CGFloat = 8.0
    }
}
