//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 11.07.2024.
//

import UIKit

protocol TrackerViewCellDelegate: AnyObject {
    func didTapCompleteButton(tracker: Tracker, isCompleted: Bool)
}

class TrackerViewCell: UICollectionViewCell {
    
    static let identifier = "TrackerCell"
    weak var delegate: TrackerViewCellDelegate?
    
    // Cell view
    private var tracker: Tracker?
    private var calendarDate = Date()
    private var isComplete = false
    
    private let trackerCellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    // Cell content
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .ypWhite
        label.numberOfLines = 0
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "add_button"), for: .normal)
        button.tintColor = .ypWhite
        button.layer.masksToBounds = true
        button.backgroundColor = .clear
        return button
    }()
    
    var trackerID: UUID?
    
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
        completeButton.isSelected = false
        completeButton.setImage(UIImage(named: "add_button"), for: .normal)
        completeButton.tintColor = .white
        completeButton.backgroundColor = nil
        completeButton.layer.opacity = 1
    }
    
    // Make UI for cell
    private func setTrackerCell() {
        let sizeButton = CGFloat(34)
        completeButton.layer.cornerRadius = sizeButton / 2
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        let cellView = [trackerCellView, emojiLabel, titleLabel, daysLabel, completeButton]
        cellView.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        trackerCellView.layer.cornerRadius = 10

        NSLayoutConstraint.activate([
            trackerCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerCellView.heightAnchor.constraint(equalToConstant: 90),
        ])
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: trackerCellView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: trackerCellView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: trackerCellView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trackerCellView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: trackerCellView.bottomAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            daysLabel.topAnchor.constraint(equalTo: trackerCellView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: trackerCellView.leadingAnchor, constant: 12),
        ])
        
        NSLayoutConstraint.activate([
            completeButton.topAnchor.constraint(equalTo: trackerCellView.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            completeButton.widthAnchor.constraint(equalToConstant: sizeButton),
            completeButton.heightAnchor.constraint(equalToConstant: sizeButton)
        ])
    }
    
    func configTrackerCell(with tracker: Tracker, days: Int, isCompleted: Bool, calendar: Date) {
        self.isComplete = isCompleted
        self.calendarDate = calendar
        self.tracker = tracker
        
        emojiLabel.text = tracker.emoji
        daysLabel.text = "\(days) \(days == 1 ? "день" : "дней")"
        completeButton.isSelected = isCompleted
        isSelected(completeButton, color: tracker.color)
        titleLabel.text = tracker.name
        trackerCellView.backgroundColor = tracker.color
        emojiLabel.backgroundColor = tracker.color.withAlphaComponent(0.3)
    }
    
    private func isSelected(_ sender: UIButton, color: UIColor) {
        if sender.isSelected {
            sender.setImage(UIImage(named: "done_button"), for: .normal)
            sender.tintColor = color
            sender.backgroundColor = .clear
            sender.layer.opacity = 0.3
        } else {
            sender.setImage(UIImage(named: "add_button"), for: .normal)
            sender.tintColor = .white
            sender.backgroundColor = color
            sender.layer.opacity = 1
        }
    }
    
    @objc private func completeButtonTapped(_ sender: UIButton) {
        guard calendarDate < Date() else { return }
        guard let tracker else { return }
        completeButton.isSelected = !sender.isSelected
        //isSelected(sender, color: tracker.color)
        let status = sender.isSelected
        delegate?.didTapCompleteButton(tracker: tracker, isCompleted: status)
    }
}
