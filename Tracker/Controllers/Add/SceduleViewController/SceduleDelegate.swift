//
//  SceduleDelegate.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 15.07.2024.
//

import Foundation

protocol SceduleDelegate: AnyObject {
    func didChoseDays(_ days: [Weekdays])
}
