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
        dateSelector.locale = .current
        dateSelector.datePickerMode = .date
        return dateSelector
    }()
    
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
            
            trackerStarLabel.heightAnchor.constraint(equalToConstant: 80),
            trackerStarLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerStarLabel.topAnchor.constraint(equalTo: trackerStarImageView.bottomAnchor, constant: -8)
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
    
    @objc private func addTrackerButton() {
        print("Button AddTracker pushed")
    }
}

