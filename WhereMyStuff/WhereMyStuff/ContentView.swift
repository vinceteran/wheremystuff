//
//  ContentView.swift
//  WhereMyStuff
//
//  Created by Vince Teran on 4/27/26.
//

import SwiftUI

// MARK: - Model
struct Recipe: Identifiable {
    let id = UUID()
    var title: String
    var imageName: String
    var instructions: String
}

// MARK: - Sample Data
let sampleRecipes = [
    Recipe(title: "Car Keys",
           imageName: "carkeys",
           instructions: "You left your car keys on top of the kitchen counter next to the coffee machine!"),
    Recipe(title: "Trusty screwdriver",
           imageName: "screwdriver",
           instructions: "Your trusty screwdriver is located in the third drawer from the top in the big red tool box in the garage."),
    Recipe(title: "Headphones",
           imageName: "headphones",
           instructions: "Your headphones can be found inside your center console in your car"),
    Recipe(title: "Spare keys",
           imageName: "spare",
           instructions: "The spare keys can be located inside of the safe in your house!"),
    Recipe(title: "Ipad mini",
           imageName: "ipad",
           instructions: "The ipad mini can be found charging on the couch in the living room."),
    Recipe(title: "Extra Batteries",
           imageName: "battery",
           instructions: "Extra batteries can be found inside the pantry or in the junk drawer above the laundry machine.")
]

// MARK: - Home View
struct HomeView: View {
    @State private var searchText = ""
    @State private var recipes: [Recipe] = sampleRecipes
    @State private var showingAddItem = false
    
    // Filtered recipes
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeCardView(recipe: recipe)
                        }
                        
                        
                    }
                }
                .padding()
            }
            .navigationTitle("My Stuff")
            .searchable(text: $searchText, prompt: "Search for an item")
            
            // ➕ BUTTON
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddItem = true
                }) {
                    Image(systemName: "plus")
                }
            )
            
            // SHEET (New Item Screen)
            .sheet(isPresented: $showingAddItem) {
                AddItemView { newItem in
                    recipes.append(newItem)
                }
            }
        }
    }
}

// MARK: - Add Item View (Blank Page)
struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var instructions = ""
    
    var onSave: (Recipe) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Name")) {
                    TextField("Enter item name", text: $title)
                }
                
                Section(header: Text("Instructions")) {
                    TextField("Where is it located?", text: $instructions)
                }
            }
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
            
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    let newItem = Recipe(
                        title: title.isEmpty ? "Untitled Item" : title,
                        imageName: "placeholder", // fallback image
                        instructions: instructions
                    )
                    
                    onSave(newItem)
                    dismiss()
                }
            )
        }
    }
}

// MARK: - Card View
struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack {
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .clipped()
                .cornerRadius(10)
            
            Text(recipe.title)
                .font(.headline)
                .padding(.top, 5)
                .multilineTextAlignment(.center)
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

// MARK: - Detail View (FIXED)
struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Image(recipe.imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                
                Text("Instructions")
                    .font(.title2)
                    .bold()
                
                Text(recipe.instructions)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(recipe.title)
    }
}

// MARK: - App Entry
struct RecipeApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}


