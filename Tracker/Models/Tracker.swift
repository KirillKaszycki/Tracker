//
//  Tracker.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 08.07.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekdays]
}

enum Weekdays: String, CaseIterable {
    case Sunday = "Воскресенье"
    case Monday = "Понедельник"
    case Tuesday = "Вторник"
    case Wednesday = "Среда"
    case Thursday = "Четверг"
    case Friday = "Пятница"
    case Saturday = "Суббота"
    
    var shortName: String {
        switch self {
        case .Sunday: return "Вс"
        case .Monday: return "Пн"
        case .Tuesday: return "Вт"
        case .Wednesday: return "Ср"
        case .Thursday: return "Чт"
        case .Friday: return "Пт"
        case .Saturday: return "Сб"
        }
    }
    
    var calendarNumber: Int {
        switch self {
        case .Sunday: return 0
        case .Monday: return 1
        case .Tuesday: return 2
        case .Wednesday: return 3
        case .Thursday: return 4
        case .Friday: return 5
        case .Saturday: return 6
        }
    }
}
