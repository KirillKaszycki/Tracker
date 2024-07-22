//
//  SceduleCellDelegate.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 15.07.2024.
//

import Foundation

protocol ScheduleCellDelegate: AnyObject {
    func buttonClicked(to isSelected: Bool, of day: Weekdays)
}
