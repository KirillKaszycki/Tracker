//
//  SwitchCell.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 15.07.2024.
//

import UIKit

final class SwitchCell: UITableViewCell {
    weak var delegate: ScheduleCellDelegate?
    private var days: Weekdays?
    
    //MARK: UI config
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypBlack
        return view
    }()
    
    private lazy var cellHeader: UILabel = {
        let header = UILabel()
        header.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        header.textColor = .black
        return header
    }()
    
    private lazy var dayEnableSwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .systemBlue
        switcher.addTarget(self, action: #selector(switcherTapped), for: .valueChanged)
        return switcher
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.backgroundColor = UIColor(named: "TextFieldBackGround")
        let contentViewHeight = contentView.heightAnchor.constraint(equalToConstant: 75)
        contentViewHeight.isActive = true
        
        let views = [separatorView, cellHeader, dayEnableSwitch]
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cellHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            cellHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellHeader.heightAnchor.constraint(equalToConstant: 22),
            
            dayEnableSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dayEnableSwitch.centerYAnchor.constraint(equalTo: cellHeader.centerYAnchor),
        ])
    }
    
    func configureDayCell(with day: Weekdays, isLastCell: Bool, isSelected: Bool) {
        self.days = day
        cellHeader.text = days?.rawValue
        separatorView.isHidden = isLastCell
        dayEnableSwitch.isOn = isSelected
    }
    
    @objc private func switcherTapped(_ sender: UISwitch) {
        guard let weekDay = days else { return }
        delegate?.buttonClicked(to: sender.isOn, of: weekDay)
    }
}
