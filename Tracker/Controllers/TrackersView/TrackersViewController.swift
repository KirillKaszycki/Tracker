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
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: LifeTime
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        configureNavigation()
        configCollectionViewCell()
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
    
    private func configCollectionViewCell () {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 9
        flowLayout.headerReferenceSize = .init(width: view.frame.size.width, height: 40)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            TrackerViewCell.self,
            forCellWithReuseIdentifier: "TrackerViewCell"
        )
        collectionView.register(
            TrackersHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "TrackersHeaderReusableView"
        )
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
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

extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackers[section].trackersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerViewCell", for: indexPath) as? TrackerViewCell else {
            fatalError("Cell presenting error")
        }
        let tracker = trackers[indexPath.section].trackersArray[indexPath.item]
        
        let days = completedTrackers.filter { $0.id == tracker.id }.count
        let isTerminated = completedTrackers.contains { $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        
        cell.configTrackerCell(with: tracker, days: days, isCompleted: isTerminated)
        cell.buttonTap = { [weak self] in
            self?.setUpTrackerCellTermination(for: tracker)
            
            if let cell = collectionView.cellForItem(at: indexPath) as? TrackerViewCell {
                let days = self?.completedTrackers.filter { $0.id == tracker.id }.count ?? 0
                let isTerminated = self?.completedTrackers.contains {
                    $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: self?.selectedDate ?? Date())
                } ?? false
                cell.configTrackerCell(with: tracker, days: days, isCompleted: isTerminated)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 9
        let availableWidth = collectionView.frame.width - padding
        let width = availableWidth / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackersHeaderReusableView", for: indexPath) as? TrackersHeaderReusableView else {
                return UICollectionReusableView()
            }
            view.titleArea.text = trackers[indexPath.section].header
            return view
        default: return UICollectionReusableView()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackers.count
    }
}
