//
//  PackingList.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import Foundation

struct PackingList: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var sportType: String
    var items: [UUID] // IDs из SportItem
    var checkedItems: Set<UUID> // Отмеченные элементы
    
    init(
        id: UUID = UUID(),
        name: String,
        sportType: String,
        items: [UUID] = [],
        checkedItems: Set<UUID> = []
    ) {
        self.id = id
        self.name = name
        self.sportType = sportType
        self.items = items
        self.checkedItems = checkedItems
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, sportType, items, checkedItems
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        sportType = try container.decode(String.self, forKey: .sportType)
        items = try container.decode([UUID].self, forKey: .items)
        let checkedItemsArray = try container.decode([UUID].self, forKey: .checkedItems)
        checkedItems = Set(checkedItemsArray)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(sportType, forKey: .sportType)
        try container.encode(items, forKey: .items)
        try container.encode(Array(checkedItems), forKey: .checkedItems)
    }
}

// Дефолтные категории для быстрого добавления
let defaultCategories: [(String, ItemCategory)] = [
    ("Кроссовки", .footwear),
    ("Футболки", .clothing),
    ("Шорты", .clothing),
    ("Штаны", .clothing),
    ("Куртка", .clothing),
    ("Рюкзак", .accessories),
    ("Бутылка", .accessories),
    ("Гантели", .equipment),
    ("Коврик", .equipment)
]

