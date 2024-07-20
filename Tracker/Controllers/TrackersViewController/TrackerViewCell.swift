//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 11.07.2024.
//

import UIKit

class TrackerViewCell: UICollectionViewCell {
    // Cell view
    private let trackerCellView = UIView()
    private let trackerEmojiView = UIView()
    // Cell content
    let emojiArea = UILabel()
    let daysArea = UILabel()
    let titleArea = UILabel()
    let cellActionButton = UIButton(type: .system)
    var trackerID: UUID?
    // Cell interaction
    var buttonTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTrackerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = nil
    }
    
    // Make UI for cell
    private func setTrackerCell() {
        // Config general UI for cell
        let cellView = [trackerCellView, cellActionButton]
        cellView.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        trackerCellView.layer.cornerRadius = 10

        NSLayoutConstraint.activate([
            trackerCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerCellView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        cellActionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        cellActionButton.tintColor = .ypWhite
        cellActionButton.layer.cornerRadius = 17
        cellActionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cellActionButton.topAnchor.constraint(equalTo: trackerCellView.bottomAnchor, constant: 8),
            cellActionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            cellActionButton.widthAnchor.constraint(equalToConstant: 34),
            cellActionButton.heightAnchor.constraint(equalToConstant: 34),
        ])
        
        // Filling the cell with content
        let  cellContent = [trackerEmojiView, emojiArea, titleArea, daysArea]
        cellContent.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            trackerCellView.addSubview($0)
        }
        
        trackerEmojiView.layer.cornerRadius = 12
        trackerEmojiView.backgroundColor = .ypWhite.withAlphaComponent(0.3)
        
        NSLayoutConstraint.activate([
            trackerEmojiView.widthAnchor.constraint(equalToConstant: 24),
            trackerEmojiView.heightAnchor.constraint(equalToConstant: 24),
            trackerEmojiView.topAnchor.constraint(equalTo: trackerCellView.topAnchor, constant: 12),
            trackerEmojiView.leadingAnchor.constraint(equalTo: trackerCellView.leadingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            emojiArea.centerXAnchor.constraint(equalTo: trackerEmojiView.centerXAnchor),
            emojiArea.centerYAnchor.constraint(equalTo: trackerEmojiView.centerYAnchor)
        ])
        
        titleArea.font = UIFont(name: "YPDisplay-Medium", size: 12)
        titleArea.textColor = .ypWhite
        titleArea.numberOfLines = 2
        titleArea.textAlignment = .left
        
        NSLayoutConstraint.activate([
            titleArea.topAnchor.constraint(equalTo: emojiArea.bottomAnchor, constant: 8),
            titleArea.leadingAnchor.constraint(equalTo: trackerCellView.leadingAnchor, constant: 12),
            titleArea.trailingAnchor.constraint(equalTo: trackerCellView.trailingAnchor, constant: -12),
            titleArea.bottomAnchor.constraint(lessThanOrEqualTo: trackerCellView.bottomAnchor, constant: -12)
        ])
        
        daysArea.font = UIFont(name: "YPDisplay-Medium", size: 12)
        
        NSLayoutConstraint.activate([
            daysArea.topAnchor.constraint(equalTo: trackerCellView.bottomAnchor, constant: 16),
            daysArea.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
    }
    
    func configTrackerCell(with tracker: Tracker, days: Int, isCompleted: Bool) {
        trackerID = tracker.id
        titleArea.text = tracker.name
        emojiArea.text = tracker.emoji
        daysArea.text = "\(days) дней"
        trackerCellView.backgroundColor = tracker.color

        let buttonImageName = isCompleted ? "done_button" : "add_button"
        let backgroundColor = isCompleted ? tracker.color.withAlphaComponent(0.5) : tracker.color
        cellActionButton.setImage(UIImage(named: buttonImageName), for: .normal)
        cellActionButton.backgroundColor = backgroundColor
    }
    
    @objc private func buttonTapped() {
        buttonTap?()
    }
}
