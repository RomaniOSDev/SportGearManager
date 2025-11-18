//
//  ItemsListView.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import SwiftUI

struct ItemsListView: View {
    @StateObject private var viewModel = SportItemsViewModel()
    @State private var showingAddItem = false
    @State private var selectedItem: SportItem?
    
    var body: some View {
        NavigationView {
            VStack {
                // Поиск и фильтры
                VStack(spacing: 12) {
                    SearchBar(text: $viewModel.searchText)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            CategoryFilterButton(
                                title: "All",
                                isSelected: viewModel.selectedCategory == nil
                            ) {
                                viewModel.selectedCategory = nil
                            }
                            
                            ForEach(ItemCategory.allCases, id: \.self) { category in
                                CategoryFilterButton(
                                    title: category.rawValue,
                                    isSelected: viewModel.selectedCategory == category
                                ) {
                                    viewModel.selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 8)
                
                // Список экипировки
                if viewModel.filteredItems.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "tshirt.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No Gear")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Tap + to add")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.filteredItems) { item in
                            ItemRowView(item: item, viewModel: viewModel)
                                .onTapGesture {
                                    selectedItem = item
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.deleteItem(viewModel.filteredItems[index])
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.backColorApp)
                }
            }
            .background(Color.backColorApp)
            .navigationTitle("My Gear")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddItem = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.mainColorApp)
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                ItemEditView(item: nil)
            }
            .sheet(item: $selectedItem) { item in
                ItemEditView(item: item)
            }
        }
        .background(Color.backColorApp)
    }
}

struct ItemRowView: View {
    let item: SportItem
    @ObservedObject var viewModel: SportItemsViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Изображение
            if let imageData = item.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                
                if let brand = item.brand {
                    Text(brand)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Label("\(item.usageCount)", systemImage: "arrow.triangle.2.circlepath")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Индикатор состояния
                    ConditionIndicator(condition: item.condition)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(item.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.mainColorApp.opacity(0.1))
                    .foregroundColor(.mainColorApp)
                    .cornerRadius(8)
                
                Button(action: {
                    viewModel.incrementUsage(for: item)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.mainColorApp)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct ConditionIndicator: View {
    let condition: Double
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { index in
                Circle()
                    .fill(index < Int(condition * 5) ? Color.green : Color.gray.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.mainColorApp : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

