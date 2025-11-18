//
//  SportItem.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import Foundation

struct SportItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ItemCategory
    var brand: String?
    var purchaseDate: Date
    var imageData: Data?
    var condition: Double // 0.0 - 1.0 (износ)
    var lastCleaned: Date?
    var usageCount: Int
    var notes: String
    
    init(
        id: UUID = UUID(),
        name: String,
        category: ItemCategory,
        brand: String? = nil,
        purchaseDate: Date = Date(),
        imageData: Data? = nil,
        condition: Double = 1.0,
        lastCleaned: Date? = nil,
        usageCount: Int = 0,
        notes: String = ""
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.brand = brand
        self.purchaseDate = purchaseDate
        self.imageData = imageData
        self.condition = condition
        self.lastCleaned = lastCleaned
        self.usageCount = usageCount
        self.notes = notes
    }
}

enum ItemCategory: String, CaseIterable, Codable {
    case footwear = "Footwear"
    case clothing = "Clothing"
    case equipment = "Equipment"
    case accessories = "Accessories"
    case other = "Other"
}

