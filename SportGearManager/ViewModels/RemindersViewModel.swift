//
//  RemindersViewModel.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import Foundation
import Combine

class RemindersViewModel: ObservableObject {
    @Published var reminders: [MaintenanceReminder] = []
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Подписываемся на изменения в DataManager
        dataManager.$reminders
            .map { reminders in
                reminders.filter { !$0.isCompleted }
                    .sorted { $0.dueDate < $1.dueDate }
            }
            .assign(to: &$reminders)
    }
    
    func loadReminders() {
        // Данные обновляются автоматически через Combine
    }
    
    func getItem(for reminder: MaintenanceReminder) -> SportItem? {
        return dataManager.sportItems.first { $0.id == reminder.itemId }
    }
    
    func completeReminder(_ reminder: MaintenanceReminder) {
        dataManager.completeReminder(reminder)
    }
    
    func deleteReminder(_ reminder: MaintenanceReminder) {
        dataManager.deleteReminder(reminder)
    }
    
    func addReminder(_ reminder: MaintenanceReminder) {
        dataManager.addReminder(reminder)
    }
    
    func updateReminder(_ reminder: MaintenanceReminder) {
        dataManager.updateReminder(reminder)
    }
}

