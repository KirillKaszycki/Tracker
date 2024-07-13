//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 13.07.2024.
//

import UIKit

final class AddTrackerViewController: UIViewController {
    weak var delegate: AddTrackerDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = UIFont(name: "YSDisplay-Medium", size: 16)
        label.textAlignment = .center
        label.textColor = .ypBlack
        return label
    }()
    
    let habbitButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.textColor = .ypWhite
        button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 16)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .ypBlack
        return button
    }()
    
    let irregularEventButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.textColor = .ypWhite
        button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 16)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureButtons()
        configureLabel()
    }
    
    private func configureButtons() {
        let buttons = [habbitButton, irregularEventButton]
        buttons.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            habbitButton.heightAnchor.constraint(equalToConstant: 60),
            habbitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habbitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            habbitButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 8),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            irregularEventButton.topAnchor.constraint(equalTo: habbitButton.bottomAnchor, constant: 16)
        ])
        
        habbitButton.addTarget(self, action: #selector(didTapHabbitButton), for: .touchUpInside)
        irregularEventButton.addTarget(self, action: #selector(didTapIrregularEventButton), for: .touchUpInside)
    }
    
    private func configureLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func didTapHabbitButton() {
        
    }
    
    @objc func didTapIrregularEventButton() {
        
    }
}
