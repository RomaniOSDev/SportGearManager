//
//  RemindersView.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import SwiftUI

struct RemindersView: View {
    @StateObject private var viewModel = RemindersViewModel()
    @State private var showingAddReminder = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.reminders.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No Active Reminders")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Reminders will appear automatically or you can create them manually")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .background(Color.backColorApp)
                } else {
                    List {
                        ForEach(viewModel.reminders) { reminder in
                            ReminderRowView(reminder: reminder, viewModel: viewModel)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.backColorApp)
                }
            }
            .background(Color.backColorApp)
            .navigationTitle("Reminders")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddReminder = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.mainColorApp)
                    }
                }
            }
            .sheet(isPresented: $showingAddReminder) {
                ReminderEditView(reminder: nil)
            }
        }
        .background(Color.backColorApp)
    }
}

struct ReminderRowView: View {
    let reminder: MaintenanceReminder
    @ObservedObject var viewModel: RemindersViewModel
    
    var body: some View {
        if let item = viewModel.getItem(for: reminder) {
            HStack(spacing: 12) {
                // Иконка типа напоминания
                Image(systemName: iconForReminderType(reminder.type))
                    .font(.title2)
                    .foregroundColor(colorForReminderType(reminder.type))
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(reminder.type.rawValue)
                        .font(.headline)
                    
                    Text(item.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(formatDate(reminder.dueDate))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Button(action: {
                        viewModel.completeReminder(reminder)
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.mainColorApp)
                            .font(.title2)
                    }
                    
                    Button(action: {
                        viewModel.deleteReminder(reminder)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func iconForReminderType(_ type: ReminderType) -> String {
        switch type {
        case .cleaning:
            return "drop.fill"
        case .replacement:
            return "exclamationmark.triangle.fill"
        case .inspection:
            return "eye.fill"
        }
    }
    
    private func colorForReminderType(_ type: ReminderType) -> Color {
        switch type {
        case .cleaning:
            return .mainColorApp
        case .replacement:
            return .orange
        case .inspection:
            return .mainColorApp
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

