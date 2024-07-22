//
//  AddTrackerDelegate.swift
//  Tracker
//
//  Created by Кирилл Кашицкий on 13.07.2024.
//

import Foundation

protocol AddTrackerDelegate: AnyObject {
    func didCreateNewTracker(_ tracker: Tracker, category: String)
}
