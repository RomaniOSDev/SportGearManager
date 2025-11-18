//
//  ReminderEditView.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import SwiftUI

struct ReminderEditView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = RemindersViewModel()
    @StateObject private var itemsViewModel = SportItemsViewModel()
    
    let reminder: MaintenanceReminder?
    
    @State private var selectedItemId: UUID?
    @State private var reminderType: ReminderType = .cleaning
    @State private var dueDate: Date = Date()
    
    init(reminder: MaintenanceReminder?) {
        self.reminder = reminder
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item")) {
                    if itemsViewModel.items.isEmpty {
                        Text("No items available. Add gear first.")
                            .foregroundColor(.secondary)
                    } else {
                        Picker("Select Item", selection: $selectedItemId) {
                            Text("Select an item").tag(nil as UUID?)
                            ForEach(itemsViewModel.items) { item in
                                Text(item.name).tag(item.id as UUID?)
                            }
                        }
                    }
                }
                
                Section(header: Text("Reminder Type")) {
                    Picker("Type", selection: $reminderType) {
                        ForEach(ReminderType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                }
            }
            .background(Color.backColorApp)
            .navigationTitle(reminder == nil ? "New Reminder" : "Edit Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.mainColorApp)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveReminder()
                    }
                    .disabled(selectedItemId == nil)
                    .foregroundColor(.mainColorApp)
                }
            }
            .onAppear {
                loadReminderData()
            }
        }
        .background(Color.backColorApp)
    }
    
    private func loadReminderData() {
        if let reminder = reminder {
            selectedItemId = reminder.itemId
            reminderType = reminder.type
            dueDate = reminder.dueDate
        }
    }
    
    private func saveReminder() {
        guard let itemId = selectedItemId else { return }
        
        if let existingReminder = reminder {
            var updatedReminder = existingReminder
            updatedReminder.itemId = itemId
            updatedReminder.type = reminderType
            updatedReminder.dueDate = dueDate
            viewModel.updateReminder(updatedReminder)
        } else {
            let newReminder = MaintenanceReminder(
                itemId: itemId,
                type: reminderType,
                dueDate: dueDate
            )
            viewModel.addReminder(newReminder)
        }
        
        dismiss()
    }
}

