//
//  ViewController.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 25.06.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    //MARK: Variables
    private var currentDate: Date = Date()
    private var geometry = Geometry(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    private var shownCategories: [TrackerCategory] = []
    private var categories: [TrackerCategory] = []
    private var terminatedTrackers: [TrackerRecord] = []

    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private lazy var addBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "add_button"),
            style: .plain,
            target: self,
            action: #selector(addButton)
        )
        button.tintColor = .ypBlack
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return datePicker
    }()
    
    private let imageStar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tracker_star")
        return imageView
    }()
    
    private let starLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy private var subView: [UIView] = [self.collectionView, self.imageStar, self.starLabel]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupNavigationBar()
        setupCollectionView()
        createMockData()
    }
    
    //MARK: Methods
    private func updateVisibleCategories() {
        shownCategories = getVisibleCategories()
        updateEmptyState()
        collectionView.reloadData()
    }
    
    private func updateEmptyState() {
        let isEmpty = shownCategories.isEmpty
        imageStar.isHidden = !isEmpty
        starLabel.isHidden = !isEmpty
    }
    
    private func getVisibleCategories() -> [TrackerCategory] {
        guard let currentDayOfWeek = Weekdays.from(date: currentDate) else {
            return []
        }
        
        return categories.compactMap { category in
            let trackers = category.trackersArray.filter { $0.schedule.contains(currentDayOfWeek) }
            
            return trackers.isEmpty ? nil : TrackerCategory(header: category.header, trackersArray: trackers)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = addBarButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.ypBlack]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: TrackerViewCell.identifier)
        collectionView.register(TrackersHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackersHeaderReusableView.identifier)
    }
    
    private func layout() {
        view.backgroundColor = .white
        
        for view in subView {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            starLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -220),
            starLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        ])
        
        NSLayoutConstraint.activate([
            imageStar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageStar.bottomAnchor.constraint(equalTo: starLabel.topAnchor, constant: -8),
            imageStar.widthAnchor.constraint(equalToConstant: 80),
            imageStar.heightAnchor.constraint(equalToConstant: 80),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func addButton() {
        let newTrackerViewController = AddTrackerViewController()
        newTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: newTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        currentDate = selectedDate
        updateVisibleCategories()
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return shownCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackerCategory = shownCategories[section]
        return trackerCategory.trackersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerViewCell.identifier,
            for: indexPath) as? TrackerViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        let trackerCategory = shownCategories[indexPath.section]
        let tracker = trackerCategory.trackersArray[indexPath.row]
        let counter = terminatedTrackers.filter { $0.id == tracker.id }.count
        let isComplete = terminatedTrackers.filter { $0.id == tracker.id && $0.date == currentDate }.count > 0
        
        cell.configTrackerCell(with: tracker, days: counter, isCompleted: isComplete, calendar: currentDate)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let viewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackersHeaderReusableView.identifier, for: indexPath) as? TrackersHeaderReusableView else {
            return UICollectionReusableView()
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            let trackerCategory = shownCategories[indexPath.section]
            viewHeader.configure(trackerCategory.header)
            return viewHeader
        }
        return viewHeader
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - geometry.paddingWidth
        let cellWidth =  availableWidth / CGFloat(geometry.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: geometry.leftInset, bottom: 0, right: geometry.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        geometry.cellSpacing
    }
    
    //Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 18)
    }
    
}

//MARK: - NewCreateTrackerDelegate
extension TrackersViewController: AddNewHabbitDelegate {
    func didCreateNewTracker(_ tracker: Tracker, category: String) {
        if let index = categories.firstIndex(where: { $0.header == category }) {
            let updatedCategory = categories[index]
            var updatedTrackers = updatedCategory.trackersArray
            updatedTrackers.append(tracker)
            categories[index] = TrackerCategory(header: updatedCategory.header, trackersArray: updatedTrackers)
        } else {
            let newCategory = TrackerCategory(header: category, trackersArray: [tracker])
            categories.append(newCategory)
        }
        
        updateVisibleCategories()
        collectionView.reloadData()
        
    }
}

//MARK: - TrackerCollectionViewCellDelegate
extension TrackersViewController: TrackerViewCellDelegate {
    func didTapCompleteButton(tracker: Tracker, isCompleted: Bool) {
        if isCompleted {
            let trackerRecord = TrackerRecord(id: tracker.id, date: currentDate)
            terminatedTrackers.append(trackerRecord)
        } else {
            terminatedTrackers.removeAll { $0.id == tracker.id && $0.date == currentDate }
        }
        
        updateCellForTracker(tracker)
    }
    
    private func updateCellForTracker(_ tracker: Tracker) {
        for section in 0..<shownCategories.count {
            if let row = shownCategories[section].trackersArray.firstIndex(where: { $0.id == tracker.id }) {
                let indexPath = IndexPath(row: row, section: section)
                collectionView.reloadItems(at: [indexPath])
                break
            }
        }
    }
}



extension TrackersViewController {
    func createMockData() {
        let tracker1 = Tracker(id: UUID(), name: "Поливать растения", color: UIColor.systemGreen, emoji: "❤️", schedule: Weekdays.allCases)
        let tracker2 = Tracker(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: UIColor.orange, emoji: "😻", schedule: Weekdays.allCases)
        let tracker3 = Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапе", color: UIColor.red, emoji: "🌺", schedule: Weekdays.allCases)
        let tracker4 = Tracker(id: UUID(), name: "Свидания в апреле", color: UIColor.blue, emoji: "❤️", schedule: Weekdays.allCases)
        let category1 = TrackerCategory(header: "Домашний уют", trackersArray: [tracker1])
        let category2 = TrackerCategory(header: "Радостные мелочи", trackersArray: [tracker2, tracker3, tracker4])
        
        categories = [category1, category2]
        updateVisibleCategories()
    }
}

// MARK: - Header Config

final class TrackersHeaderReusableView: UICollectionReusableView {
    
    static let identifier = "TrackerHeader"
    
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.text = "Домашний уют"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(headerLabel)
    }
    private func configureView() {
        NSLayoutConstraint.activate([
            headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 28),
            headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configure(_ category: String) {
        headerLabel.text = category
    }
}

