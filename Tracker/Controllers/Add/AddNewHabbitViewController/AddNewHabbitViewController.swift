//
//  AddNewHabbitViewController.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 13.07.2024.
//

import UIKit

final class AddNewHabbitViewController: UIViewController {
    weak var habbitDelegate: AddNewHabbitDelegate?
    weak var scheduleDelegate: ScheduleDelegate?
    
    private var days: [Weekdays] = []
    
    private var habit: [(name: String, settings: String)] = [
        (name: "Категория", settings: ""),
        (name: "Расписание", settings: "")
    ]
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.layer.cornerRadius = 10
        tableView.sectionHeaderHeight = 0
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        tableView.tableHeaderView = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let titleArea: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont(name: "YSDisplay-Medium", size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let nameTextArea: UITextField = {
        let area = UITextField()
        area.backgroundColor = UIColor(named: "TextFieldColor")
        area.layer.cornerRadius = 10
        area.placeholder = "    Введите название трекера"
        area.font = UIFont(name: "YSDisplay-Medium", size: 17)
        area.clearButtonMode = .whileEditing
        return area
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    private lazy var clearTextAreaButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "error_clear"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func addTargetsForUIElements() {
        nameTextArea.addTarget(self, action: #selector(textAreaChanged), for: .editingChanged)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func configureView() {
        let width = (view.frame.width - 48) / 2
        
        let views = [tableView, titleArea, nameTextArea, addButton, cancelButton]
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: nameTextArea.bottomAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            titleArea.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleArea.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            nameTextArea.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextArea.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextArea.topAnchor.constraint(equalTo: titleArea.bottomAnchor, constant: 38),
            nameTextArea.heightAnchor.constraint(equalToConstant: 75),
            
            addButton.widthAnchor.constraint(equalToConstant: width),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: width),
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func verification() {
        if let text = nameTextArea.text, !text.isEmpty && !days.isEmpty {
            addButton.backgroundColor = .ypBlack
            addButton.isEnabled = true
        } else {
            addButton.backgroundColor = .ypGray
            addButton.isEnabled = false
        }
    }
    
    @objc private func textAreaChanged(_ textArea: UITextField) {
        if let text = textArea.text, !text.isEmpty {
            clearTextAreaButton.isHidden = false
        } else {
            clearTextAreaButton.isHidden = true
        }
        verification()
    }
    
    @objc private func addButtonTapped() {
        guard let trackerHeader = nameTextArea.text else { return }
        let newTracker = Tracker(
            id: UUID(),
            name: trackerHeader,
            color: .cSelection4,
            emoji: "😳",
            schedule: days
        )
        habbitDelegate?.didAddNewHAbbit(newTracker)
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        days.removeAll()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func clearTextAreaButtonClicked() {
        nameTextArea.text = ""
        clearTextAreaButton.isHidden = true
    }
    
    func didChoseDays(_ days: [Weekdays]) {
        let chosenDays = days
        let schedule = days.isEmpty ? "" : days.map { $0.shortName }.joined(separator: ", ")
        habit[1].settings = schedule
        tableView.reloadData()
        dismiss(animated: true)
    }
}
