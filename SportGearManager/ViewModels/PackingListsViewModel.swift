//
//  PackingListsViewModel.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import Foundation
import Combine

class PackingListsViewModel: ObservableObject {
    @Published var packingLists: [PackingList] = []
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Подписываемся на изменения в DataManager
        dataManager.$packingLists
            .assign(to: &$packingLists)
    }
    
    func loadLists() {
        // Данные обновляются автоматически через Combine
    }
    
    func addList(_ list: PackingList) {
        dataManager.addPackingList(list)
    }
    
    func updateList(_ list: PackingList) {
        dataManager.updatePackingList(list)
    }
    
    func deleteList(_ list: PackingList) {
        dataManager.deletePackingList(list)
    }
    
    func toggleItem(listId: UUID, itemId: UUID) {
        dataManager.toggleItemInPackingList(listId: listId, itemId: itemId)
    }
    
    func getItems(for list: PackingList) -> [SportItem] {
        return dataManager.sportItems.filter { list.items.contains($0.id) }
    }
}

