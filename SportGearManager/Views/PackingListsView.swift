//
//  PackingListsView.swift
//  SportGearManager
//
//  Created by Роман Главацкий on 18.11.2025.
//

import SwiftUI

struct PackingListsView: View {
    @StateObject private var viewModel = PackingListsViewModel()
    @State private var showingAddList = false
    @State private var selectedList: PackingList?
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.packingLists.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "checklist")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No Packing Lists")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Create a packing list to prepare for your workouts")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .background(Color.backColorApp)
                } else {
                    List {
                        ForEach(viewModel.packingLists) { list in
                            PackingListRowView(list: list, viewModel: viewModel)
                                .onTapGesture {
                                    selectedList = list
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.deleteList(viewModel.packingLists[index])
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.backColorApp)
                }
            }
            .background(Color.backColorApp)
            .navigationTitle("Packing Lists")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddList = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.mainColorApp)
                    }
                }
            }
            .sheet(isPresented: $showingAddList) {
                PackingListEditView(list: nil)
            }
            .sheet(item: $selectedList) { list in
                PackingListDetailView(list: list)
            }
        }
        .background(Color.backColorApp)
    }
}

struct PackingListRowView: View {
    let list: PackingList
    @ObservedObject var viewModel: PackingListsViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(list.name)
                    .font(.headline)
                
                Text(list.sportType)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(list.checkedItems.count) / \(list.items.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if !list.items.isEmpty {
                ProgressView(value: Double(list.checkedItems.count), total: Double(list.items.count))
                    .frame(width: 50)
            }
        }
        .padding(.vertical, 4)
    }
}

struct PackingListDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = PackingListsViewModel()
    @StateObject private var itemsViewModel = SportItemsViewModel()
    
    let list: PackingList
    
    @State private var currentList: PackingList
    
    init(list: PackingList) {
        self.list = list
        _currentList = State(initialValue: list)
    }
    
    private var itemsForList: [SportItem] {
        viewModel.getItems(for: currentList)
    }
    
    private var sectionHeader: String {
        "Gear (\(currentList.checkedItems.count)/\(currentList.items.count))"
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Information")) {
                    Text(currentList.name)
                        .font(.headline)
                    Text(currentList.sportType)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text(sectionHeader)) {
                    if currentList.items.isEmpty {
                        Text("Add gear to the packing list")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(itemsForList, id: \.id) { item in
                            ItemCheckRowView(
                                item: item,
                                isChecked: currentList.checkedItems.contains(item.id),
                                onToggle: {
                                    toggleItem(itemId: item.id)
                                }
                            )
                        }
                    }
                }
            }
            .background(Color.backColorApp)
            .navigationTitle("Packing List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.mainColorApp)
                }
            }
            .onChange(of: viewModel.packingLists) { newLists in
                updateCurrentList(from: newLists)
            }
        }
        .background(Color.backColorApp)
    }
    
    private func toggleItem(itemId: UUID) {
        viewModel.toggleItem(listId: currentList.id, itemId: itemId)
        updateCurrentList(from: viewModel.packingLists)
    }
    
    private func updateCurrentList(from lists: [PackingList]) {
        if let updated = lists.first(where: { $0.id == currentList.id }) {
            currentList = updated
        }
    }
}

struct ItemCheckRowView: View {
    let item: SportItem
    let isChecked: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? .mainColorApp : .gray)
            }
            
            Text(item.name)
                .strikethrough(isChecked)
            
            Spacer()
            
            Text(item.category.rawValue)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct PackingListEditView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = PackingListsViewModel()
    @StateObject private var itemsViewModel = SportItemsViewModel()
    
    let list: PackingList?
    
    @State private var name: String = ""
    @State private var sportType: String = ""
    @State private var selectedItems: Set<UUID> = []
    
    init(list: PackingList?) {
        self.list = list
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Name", text: $name)
                    TextField("Sport Type", text: $sportType)
                }
                
                Section(header: Text("Select Gear")) {
                    if itemsViewModel.items.isEmpty {
                        Text("Add gear first")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(itemsViewModel.items) { item in
                            HStack {
                                Button(action: {
                                    if selectedItems.contains(item.id) {
                                        selectedItems.remove(item.id)
                                    } else {
                                        selectedItems.insert(item.id)
                                    }
                                }) {
                                    Image(systemName: selectedItems.contains(item.id) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedItems.contains(item.id) ? .mainColorApp : .gray)
                                }
                                
                                Text(item.name)
                                
                                Spacer()
                                
                                Text(item.category.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .background(Color.backColorApp)
            .navigationTitle(list == nil ? "New Packing List" : "Edit Packing List")
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
                        saveList()
                    }
                    .disabled(name.isEmpty || sportType.isEmpty)
                    .foregroundColor(.mainColorApp)
                }
            }
            .onAppear {
                loadListData()
            }
        }
        .background(Color.backColorApp)
    }
    
    private func loadListData() {
        if let list = list {
            name = list.name
            sportType = list.sportType
            selectedItems = Set(list.items)
        }
    }
    
    private func saveList() {
        let itemsArray = Array(selectedItems)
        
        if let existingList = list {
            var updatedList = existingList
            updatedList.name = name
            updatedList.sportType = sportType
            updatedList.items = itemsArray
            viewModel.updateList(updatedList)
        } else {
            let newList = PackingList(
                name: name,
                sportType: sportType,
                items: itemsArray
            )
            viewModel.addList(newList)
        }
        
        dismiss()
    }
}

