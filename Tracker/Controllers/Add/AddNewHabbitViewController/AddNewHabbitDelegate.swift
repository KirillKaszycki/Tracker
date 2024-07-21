//
//  AddNewHabbitDelegate.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 15.07.2024.
//

import Foundation

protocol AddNewHabbitDelegate: AnyObject {
    func didCreateNewTracker(_ tracker: Tracker, category: String)
}
