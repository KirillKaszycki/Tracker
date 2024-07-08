//
//  TabBarController.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 25.06.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersViewController = TrackersViewController()
        
        let navigationViewController = UINavigationController(rootViewController: trackersViewController)
        navigationViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackers_active"),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "statistics_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [navigationViewController, statisticsViewController]
        
        addTabBarBorder()
    }
    
    private func addTabBarBorder() {
//        let border = UIView()
//        border.backgroundColor = .lightGray
//        border.translatesAutoresizingMaskIntoConstraints = false
//        tabBar.addSubview(border)
//        
//        NSLayoutConstraint.activate([
//            border.topAnchor.constraint(equalTo: tabBar.topAnchor),
//            border.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
//            border.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
//            border.heightAnchor.constraint(equalToConstant: 1)
//        ])
        
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.ypGray.cgColor
    }
}

