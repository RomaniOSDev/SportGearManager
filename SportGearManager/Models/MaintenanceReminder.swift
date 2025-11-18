//
//  MaintenanceReminder.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import Foundation

struct MaintenanceReminder: Identifiable, Codable {
    let id: UUID
    var itemId: UUID
    var type: ReminderType
    var dueDate: Date
    var isCompleted: Bool
    
    init(
        id: UUID = UUID(),
        itemId: UUID,
        type: ReminderType,
        dueDate: Date,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.itemId = itemId
        self.type = type
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}

enum ReminderType: String, CaseIterable, Codable {
    case cleaning = "Clean"
    case replacement = "Replace"
    case inspection = "Inspect"
}

