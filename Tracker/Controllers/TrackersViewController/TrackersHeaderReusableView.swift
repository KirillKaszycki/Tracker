//
//  TrackersHeaderReusableView.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 12.07.2024.
//

//import UIKit
//
//class TrackersHeaderReusableView: UICollectionReusableView {
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        label.textColor = .ypBlack
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupViews() {
//        addSubview(titleLabel)
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//
//    func configureHeader(for category: TrackerCategory) {
//        titleLabel.text = category.header
//    }
//}

