//
//  ContentView.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @StateObject private var remindersViewModel = RemindersViewModel()
    @State private var selectedTab = 0
    
    private var remindersBadge: Int? {
        remindersViewModel.reminders.isEmpty ? nil : remindersViewModel.reminders.count
    }
    
    var body: some View {
        Group {
            if hasSeenOnboarding {
                TabView(selection: $selectedTab) {
                    ItemsListView()
                        .tabItem {
                            Label("Gear", systemImage: "tshirt.fill")
                        }
                        .tag(0)
                    
                    RemindersView()
                        .tabItem {
                            Label("Reminders", systemImage: "bell.fill")
                        }
                        .tag(1)
                        .badge(remindersBadge ?? 0)
                    
                    PackingListsView()
                        .tabItem {
                            Label("Lists", systemImage: "checklist")
                        }
                        .tag(2)
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                        .tag(3)
                }
                .background(Color.backColorApp)
            } else {
                OnboardingView()
            }
        }
        .background(Color.backColorApp)
    }
}

#Preview {
    ContentView()
}
