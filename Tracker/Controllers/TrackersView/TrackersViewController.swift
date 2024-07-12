//
//  ViewController.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 25.06.2024.
//

import UIKit

final class TrackersViewController: UIViewController {

    // MARK: Variables
    private let trackerStarImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "tracker_star")
        return image
    }()
    
    private let trackerStarLabel: UILabel = {
       let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var addTracker: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "add_button"),
            style: .plain,
            target: self,
            action: #selector(addTrackerButton)
        )
        button.tintColor = .ypBlack
        return button
    }()
    
    private lazy var dateSelector: UIDatePicker = {
        let dateSelector = UIDatePicker()
        dateSelector.widthAnchor.constraint(equalToConstant: 120).isActive = true
        dateSelector.locale = .current
        dateSelector.datePickerMode = .date
        dateSelector.preferredDatePickerStyle = .compact
        dateSelector.clipsToBounds = true
        dateSelector.locale = Locale(identifier: "ru_RU")
        dateSelector.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dateSelector)
        return dateSelector
    }()
    
    private var categories: [TrackerCategory] = [] { didSet { collectionView.reloadData() } }
    
    private var completedTrackers: [TrackerRecord] = []
    private var trackers: [TrackerCategory] = []
    
    private var selectedDate = Date()
    private var collectionView: UICollectionView!
    
    // MARK: LifeTime
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        configureNavigation()
    }
    
    // MARK: Config ViewController
    private func configureBackground() {
        view.backgroundColor = .ypWhite
        
        lazy var subView: [UIView] = [trackerStarImageView, trackerStarLabel]
        
        subView.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            trackerStarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerStarImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackerStarImageView.widthAnchor.constraint(equalToConstant: 80),
            trackerStarImageView.heightAnchor.constraint(equalToConstant: 80),
            
            trackerStarLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerStarLabel.topAnchor.constraint(equalTo: trackerStarImageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func configureNavigation() {
        navigationItem.leftBarButtonItem = addTracker
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dateSelector)
        navigationItem.title = "Трекеры"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.ypBlack]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
    }
    
    private func setUpTrackerCellTermination(for tracker: Tracker) {
        let currentDate = Date()
        let selectedDeate = dateSelector.date
        
        if Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) == .orderedDescending {
            return
        }
        if dateSelector.date <= Date() {
            if let index = completedTrackers.firstIndex(where: { $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDeate)}) {
                completedTrackers.remove(at: index)
            } else {
                let record = TrackerRecord(id: tracker.id, date: selectedDeate)
                completedTrackers.append(record)
            }
            collectionView.reloadData()
        }
    }
    
    @objc private func addTrackerButton() {
        print("Button AddTracker pushed")
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let selectedDate = sender.date
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Selected Date: \(formattedDate)")
        
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: sender.date)
        let dayNum = (day + 5) % 7
        let selectedDay = Weekdays.allCases[dayNum]
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tracker = trackers[indexPath.section].trackersArray[indexPath.item]
        setUpTrackerCellTermination(for: tracker)
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackerViewCell {
            let days = completedTrackers.filter { $0.id == tracker.id }.count
            let isTerminated = completedTrackers.contains { $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate)}
            cell.configTrackerCell(with: tracker, days: days, isCompleted: isTerminated)
        }
    }
}

//extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//}
