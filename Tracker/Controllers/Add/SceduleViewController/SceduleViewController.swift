//
//  SceduleViewController.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 15.07.2024.
//

import UIKit

final class SceduleViewController: UIViewController {
    private var days: Set<Weekdays> = []
    private weak var delegate: SceduleDelegate?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SwitchCell.self, forCellReuseIdentifier: "SwitchCell")
        table.separatorStyle = .singleLine
        table.isScrollEnabled = false
        table.sectionHeaderHeight = 0
        table.register(UITableView.self, forCellReuseIdentifier: "cell")
        table.tableHeaderView = nil
        return table
    }()
    
    private let header: UILabel = {
        let header = UILabel()
        header.text = "Расписание"
        header.textAlignment = .center
        header.font = UIFont(name: "YSDisplay-Medium", size: 16)
        return header
    }()
    
    private let isDoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 10
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureView() {
        view.backgroundColor = .ypWhite
        let views = [tableView, header, isDoneButton]
        isDoneButton.addTarget(self, action: #selector(isDoneButtonTapped), for: .touchUpInside)
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            isDoneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            isDoneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            isDoneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            isDoneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            isDoneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func isDoneButtonTapped() {
        let weekdays = Array(days)
        delegate?.didChoseDays(weekdays)
        self.dismiss(animated: true)
    }
}

extension SceduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Weekdays.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as? SwitchCell else { fatalError("No cel' found") }
        
        cell.delegate = self
        cell.selectionStyle = .none
        let day = Weekdays.allCases[indexPath.row]
        cell.configureDayCell(with: day, isLastCell: indexPath.row == 6, isSelected: days.contains(day))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
