//
//  DataManager.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var sportItems: [SportItem] = []
    @Published var reminders: [MaintenanceReminder] = []
    @Published var packingLists: [PackingList] = []
    
    private let itemsKey = "sportItems"
    private let remindersKey = "maintenanceReminders"
    private let packingListsKey = "packingLists"
    
    private init() {
        loadData()
    }
    
    // MARK: - SportItems
    
    func addItem(_ item: SportItem) {
        sportItems.append(item)
        saveData()
        checkReminders(for: item)
    }
    
    func updateItem(_ item: SportItem) {
        if let index = sportItems.firstIndex(where: { $0.id == item.id }) {
            sportItems[index] = item
            saveData()
            checkReminders(for: item)
        }
    }
    
    func deleteItem(_ item: SportItem) {
        sportItems.removeAll { $0.id == item.id }
        reminders.removeAll { $0.itemId == item.id }
        saveData()
    }
    
    func incrementUsage(for itemId: UUID) {
        if let index = sportItems.firstIndex(where: { $0.id == itemId }) {
            sportItems[index].usageCount += 1
            saveData()
            if let item = sportItems.first(where: { $0.id == itemId }) {
                checkReminders(for: item)
            }
        }
    }
    
    // MARK: - Reminders
    
    func addReminder(_ reminder: MaintenanceReminder) {
        reminders.append(reminder)
        saveData()
    }
    
    func updateReminder(_ reminder: MaintenanceReminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index] = reminder
            saveData()
        }
    }
    
    func completeReminder(_ reminder: MaintenanceReminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index].isCompleted = true
            
            // Если это напоминание о чистке, обновляем дату чистки
            if reminder.type == .cleaning {
                if let itemIndex = sportItems.firstIndex(where: { $0.id == reminder.itemId }) {
                    sportItems[itemIndex].lastCleaned = Date()
                    sportItems[itemIndex].usageCount = 0 // Сбрасываем счетчик использований
                }
            }
            
            saveData()
        }
    }
    
    func deleteReminder(_ reminder: MaintenanceReminder) {
        reminders.removeAll { $0.id == reminder.id }
        saveData()
    }
    
    // MARK: - PackingLists
    
    func addPackingList(_ list: PackingList) {
        packingLists.append(list)
        saveData()
    }
    
    func updatePackingList(_ list: PackingList) {
        if let index = packingLists.firstIndex(where: { $0.id == list.id }) {
            packingLists[index] = list
            saveData()
        }
    }
    
    func deletePackingList(_ list: PackingList) {
        packingLists.removeAll { $0.id == list.id }
        saveData()
    }
    
    func toggleItemInPackingList(listId: UUID, itemId: UUID) {
        if let index = packingLists.firstIndex(where: { $0.id == listId }) {
            if packingLists[index].checkedItems.contains(itemId) {
                packingLists[index].checkedItems.remove(itemId)
            } else {
                packingLists[index].checkedItems.insert(itemId)
            }
            saveData()
        }
    }
    
    // MARK: - Reminder Logic
    
    private func checkReminders(for item: SportItem) {
        // Проверяем, нужно ли создать напоминание о чистке (после 7 использований)
        if item.usageCount >= 7 {
            let existingReminder = reminders.first { reminder in
                reminder.itemId == item.id &&
                reminder.type == .cleaning &&
                !reminder.isCompleted
            }
            
            if existingReminder == nil {
                let reminder = MaintenanceReminder(
                    itemId: item.id,
                    type: .cleaning,
                    dueDate: Date()
                )
                addReminder(reminder)
            }
        }
        
        // Проверяем состояние износа (если меньше 0.3, предлагаем замену)
        if item.condition < 0.3 {
            let existingReminder = reminders.first { reminder in
                reminder.itemId == item.id &&
                reminder.type == .replacement &&
                !reminder.isCompleted
            }
            
            if existingReminder == nil {
                let reminder = MaintenanceReminder(
                    itemId: item.id,
                    type: .replacement,
                    dueDate: Date()
                )
                addReminder(reminder)
            }
        }
    }
    
    // MARK: - Persistence
    
    private func saveData() {
        if let itemsData = try? JSONEncoder().encode(sportItems) {
            UserDefaults.standard.set(itemsData, forKey: itemsKey)
        }
        
        if let remindersData = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(remindersData, forKey: remindersKey)
        }
        
        if let listsData = try? JSONEncoder().encode(packingLists) {
            UserDefaults.standard.set(listsData, forKey: packingListsKey)
        }
    }
    
    private func loadData() {
        if let itemsData = UserDefaults.standard.data(forKey: itemsKey),
           let decodedItems = try? JSONDecoder().decode([SportItem].self, from: itemsData) {
            sportItems = decodedItems
        }
        
        if let remindersData = UserDefaults.standard.data(forKey: remindersKey),
           let decodedReminders = try? JSONDecoder().decode([MaintenanceReminder].self, from: remindersData) {
            reminders = decodedReminders
        }
        
        if let listsData = UserDefaults.standard.data(forKey: packingListsKey),
           let decodedLists = try? JSONDecoder().decode([PackingList].self, from: listsData) {
            packingLists = decodedLists
        }
    }
}

