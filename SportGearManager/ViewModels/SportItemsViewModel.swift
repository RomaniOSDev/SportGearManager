//
//  SportItemsViewModel.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import Foundation
import SwiftUI
import Combine

class SportItemsViewModel: ObservableObject {
    @Published var items: [SportItem] = []
    @Published var selectedCategory: ItemCategory? = nil
    @Published var searchText: String = ""
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Подписываемся на изменения в DataManager
        dataManager.$sportItems
            .assign(to: &$items)
    }
    
    var filteredItems: [SportItem] {
        var filtered = items
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                (item.brand?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return filtered.sorted { $0.name < $1.name }
    }
    
    func addItem(_ item: SportItem) {
        dataManager.addItem(item)
    }
    
    func updateItem(_ item: SportItem) {
        dataManager.updateItem(item)
    }
    
    func deleteItem(_ item: SportItem) {
        dataManager.deleteItem(item)
    }
    
    func incrementUsage(for item: SportItem) {
        dataManager.incrementUsage(for: item.id)
    }
}

