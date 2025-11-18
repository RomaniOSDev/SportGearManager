//
//  ItemEditView.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import SwiftUI
import PhotosUI

struct ItemEditView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SportItemsViewModel()
    
    let item: SportItem?
    
    @State private var name: String = ""
    @State private var category: ItemCategory = .other
    @State private var brand: String = ""
    @State private var purchaseDate: Date = Date()
    @State private var condition: Double = 1.0
    @State private var notes: String = ""
    @State private var selectedImage: UIImage?
    @State private var selectedPhoto: PhotosPickerItem?
    
    init(item: SportItem?) {
        self.item = item
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Name", text: $name)
                    
                    Picker("Category", selection: $category) {
                        ForEach(ItemCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    
                    TextField("Brand (optional)", text: $brand)
                    
                    DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
                }
                
                Section(header: Text("Photo")) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 200)
                    } else if let imageData = item?.imageData,
                              let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 200)
                    }
                    
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Label(selectedImage != nil || item?.imageData != nil ? "Change Photo" : "Choose from Gallery", systemImage: "photo.on.rectangle")
                    }
                }
                
                Section(header: Text("Condition")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Wear: \(Int(condition * 100))%")
                            .font(.headline)
                        
                        Slider(value: $condition, in: 0...1, step: 0.1)
                            .tint(.mainColorApp)
                        
                        HStack {
                            Text("New")
                            Spacer()
                            Text("Worn")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .background(Color.backColorApp)
            .navigationTitle(item == nil ? "New Gear" : "Edit Gear")
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
                        saveItem()
                    }
                    .disabled(name.isEmpty)
                    .foregroundColor(.mainColorApp)
                }
            }
            .onAppear {
                loadItemData()
            }
            .onChange(of: selectedPhoto) { newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
            }
        }
        .background(Color.backColorApp)
    }
    
    private func loadItemData() {
        if let item = item {
            name = item.name
            category = item.category
            brand = item.brand ?? ""
            purchaseDate = item.purchaseDate
            condition = item.condition
            notes = item.notes
        }
    }
    
    private func saveItem() {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        if let existingItem = item {
            var updatedItem = existingItem
            updatedItem.name = name
            updatedItem.category = category
            updatedItem.brand = brand.isEmpty ? nil : brand
            updatedItem.purchaseDate = purchaseDate
            updatedItem.condition = condition
            updatedItem.notes = notes
            updatedItem.imageData = imageData ?? existingItem.imageData
            viewModel.updateItem(updatedItem)
        } else {
            let newItem = SportItem(
                name: name,
                category: category,
                brand: brand.isEmpty ? nil : brand,
                purchaseDate: purchaseDate,
                imageData: imageData,
                condition: condition,
                notes: notes
            )
            viewModel.addItem(newItem)
        }
        
        dismiss()
    }
}

