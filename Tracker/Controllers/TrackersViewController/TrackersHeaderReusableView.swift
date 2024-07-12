//
//  TrackersHeaderReusableView.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 12.07.2024.
//

import UIKit

final class TrackersHeaderReusableView: UICollectionReusableView {
    
    let titleArea = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Cell Title Area Configuration
    func configureTitleArea() {
        titleArea.translatesAutoresizingMaskIntoConstraints = false
        titleArea.textColor = .ypBlack
        titleArea.font = UIFont(name: "YSDisplay-Bold", size: 19)
        addSubview(titleArea)
        
        NSLayoutConstraint.activate([
            titleArea.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            titleArea.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])
    }
}
