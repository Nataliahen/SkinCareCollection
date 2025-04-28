//
//  ContentView.swift
//  skincareappgrok
//
//  Created by Henriquez Perez, Natalia on 4/9/25.
//
import SwiftUI

// MARK: - Custom Colors
extension Color {
    static let chanelBlack = Color(red: 0.07, green: 0.07, blue: 0.07)
    static let chanelCream = Color(red: 0.96, green: 0.95, blue: 0.93)
    static let chanelGold = Color(red: 0.85, green: 0.75, blue: 0.5)
    static let chanelGray = Color(red: 0.9, green: 0.9, blue: 0.9)
}

// MARK: - Custom Font Modifier
struct ChanelFontModifier: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: .serif))
    }
}

extension View {
    func chanelFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.modifier(ChanelFontModifier(size: size, weight: weight))
    }
}

struct Routine: Codable, Identifiable {
    let id: UUID
    let name: String
    let products: [String]
}

struct RoutineDetailView: View {
    let routine: Routine
    
    var body: some View {
        VStack {
            Text(routine.name)
                .chanelFont(size: 28, weight: .bold)
                .padding(.bottom, 20)
                .foregroundColor(.chanelBlack)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(Array(routine.products.enumerated()), id: \.element) { index, product in
                        HStack(alignment: .top) {
                            Text("Step \(index + 1)")
                                .chanelFont(size: 16, weight: .bold)
                                .foregroundColor(.chanelGold)
                                .frame(width: 80, alignment: .leading)
                            Text(product)
                                .chanelFont(size: 16)
                                .foregroundColor(.chanelBlack)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.chanelGold.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.vertical)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.chanelCream)
        .navigationTitle(routine.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.chanelBlack, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct ContentView: View {
    @State private var currentScreen = "home"
    @State private var currentRoutine: [String] = []
    @State private var savedRoutines: [Routine] = []
    @State private var skinType = ""
    @State private var selectedConcerns: Set<String> = []
    @State private var isShowingSaveSheet = false
    @State private var routineName = ""
    
    // List of available concerns
    private let concerns = [
        "acne", "dryness", "aging", "wrinkles", "hyperpigmentation", "dullness", "sun damage", "others"
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                switch currentScreen {
                case "results":
                    // Results Screen
                    VStack {
                        HStack {
                            Button(action: {
                                currentScreen = "quiz"
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Quiz")
                                }
                                .foregroundColor(.chanelGold)
                            }
                            Spacer()
                        }
                        .padding()
                        
                        Text("Your Skincare Routine")
                            .chanelFont(size: 28, weight: .bold)
                            .foregroundColor(.chanelBlack)
                            .padding(.bottom, 20)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 15) {
                                ForEach(Array(currentRoutine.enumerated()), id: \.element) { index, product in
                                    HStack(alignment: .top) {
                                        Text("Step \(index + 1)")
                                            .chanelFont(size: 16, weight: .bold)
                                            .foregroundColor(.chanelGold)
                                            .frame(width: 80, alignment: .leading)
                                        Text(product)
                                            .chanelFont(size: 16)
                                            .foregroundColor(.chanelBlack)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 0)
                                            .stroke(Color.chanelGold.opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.vertical)
                        }
                        
                        Button(action: {
                            isShowingSaveSheet = true
                        }) {
                            Text("SAVE ROUTINE")
                                .chanelFont(size: 16, weight: .bold)
                                .frame(width: 200, height: 50)
                                .background(Color.chanelBlack)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        .sheet(isPresented: $isShowingSaveSheet) {
                            VStack(spacing: 20) {
                                Text("Name Your Routine")
                                    .chanelFont(size: 22, weight: .bold)
                                    .foregroundColor(.chanelBlack)
                                
                                TextField("Enter routine name", text: $routineName)
                                    .padding()
                                    .background(Color.chanelGray)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 0)
                                            .stroke(Color.chanelGold, lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                                
                                HStack(spacing: 20) {
                                    Button(action: {
                                        isShowingSaveSheet = false
                                        routineName = ""
                                    }) {
                                        Text("CANCEL")
                                            .chanelFont(size: 16, weight: .bold)
                                            .frame(width: 120, height: 40)
                                            .background(Color.chanelGray)
                                            .foregroundColor(.chanelBlack)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 0)
                                                    .stroke(Color.chanelBlack, lineWidth: 1)
                                            )
                                    }
                                    
                                    Button(action: {
                                        let name = routineName.isEmpty ? "Routine \(savedRoutines.count + 1)" : routineName
                                        let newRoutine = Routine(id: UUID(), name: name, products: currentRoutine)
                                        savedRoutines.append(newRoutine)
                                        saveRoutines()
                                        isShowingSaveSheet = false
                                        routineName = ""
                                        currentScreen = "saved"
                                    }) {
                                        Text("SAVE")
                                            .chanelFont(size: 16, weight: .bold)
                                            .frame(width: 120, height: 40)
                                            .background(Color.chanelBlack)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(30)
                            .background(Color.chanelCream)
                            .presentationDetents([.medium])
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.chanelCream)
                    
                default:
                    // TabView for Home, Quiz, and Saved Routines
                    TabView(selection: $currentScreen) {
                        // Home Screen
                        VStack {
                            Image(systemName: "c.circle")
                                .font(.system(size: 60))
                                .foregroundColor(.chanelBlack)
                                .padding(.top, 40)
                                .padding(.bottom, 10)
                            
                            Text("SKINCARE")
                                .chanelFont(size: 36, weight: .bold)
                                .foregroundColor(.chanelBlack)
                            
                            Text("COLLECTION")
                                .chanelFont(size: 28, weight: .light)
                                .foregroundColor(.chanelBlack)
                                .padding(.bottom, 60)
                            
                            Button(action: {
                                currentScreen = "quiz"
                                skinType = ""
                                selectedConcerns.removeAll()
                            }) {
                                Text("CREATE ROUTINE")
                                    .chanelFont(size: 16, weight: .bold)
                                    .frame(width: 200, height: 50)
                                    .background(Color.chanelBlack)
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom, 20)
                            
                            Button(action: {
                                currentScreen = "saved"
                            }) {
                                Text("SAVED ROUTINES")
                                    .chanelFont(size: 16, weight: .bold)
                                    .frame(width: 200, height: 50)
                                    .foregroundColor(.chanelBlack)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 0)
                                            .stroke(Color.chanelBlack, lineWidth: 1)
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.chanelCream)
                        .tag("home")
                        .tabItem {
                            Label("Home", systemImage: "house")
                                .environment(\.symbolVariants, .none)
                        }
                        .navigationBarHidden(true)
                        
                        // Quiz Screen
                        VStack {
                            Text("Skincare Consultation")
                                .chanelFont(size: 28, weight: .bold)
                                .foregroundColor(.chanelBlack)
                                .padding(.bottom, 20)
                            
                            Menu {
                                Button("Oily", action: { skinType = "oily" })
                                Button("Dry", action: { skinType = "dry" })
                                Button("Combination", action: { skinType = "combination" })
                            } label: {
                                HStack {
                                    Text(skinType.isEmpty ? "Select Skin Type" : skinType.capitalized)
                                        .chanelFont(size: 16)
                                        .foregroundColor(.chanelBlack)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.chanelGold)
                                }
                                .padding()
                                .frame(width: 300)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(Color.chanelGold, lineWidth: 1)
                                )
                            }
                            .padding()
                            
                            Text("Select Concerns")
                                .chanelFont(size: 18, weight: .bold)
                                .foregroundColor(.chanelBlack)
                                .padding(.top, 10)
                            
                            ScrollView {
                                VStack(alignment: .leading, spacing: 15) {
                                    ForEach(concerns, id: \.self) { concern in
                                        Button(action: {
                                            if selectedConcerns.contains(concern) {
                                                selectedConcerns.remove(concern)
                                            } else {
                                                selectedConcerns.insert(concern)
                                            }
                                        }) {
                                            HStack {
                                                Image(systemName: selectedConcerns.contains(concern) ? "checkmark.square.fill" : "square")
                                                    .foregroundColor(selectedConcerns.contains(concern) ? .chanelGold : .gray)
                                                Text(concern.capitalized)
                                                    .chanelFont(size: 16)
                                                    .foregroundColor(.chanelBlack)
                                                Spacer()
                                            }
                                            .padding(.vertical, 8)
                                            .padding(.horizontal)
                                            .background(Color.white)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            Button(action: {
                                if !skinType.isEmpty && !selectedConcerns.isEmpty {
                                    currentRoutine = generateRoutine(skinType: skinType, concerns: Array(selectedConcerns))
                                    currentScreen = "results"
                                }
                            }) {
                                Text("GENERATE ROUTINE")
                                    .chanelFont(size: 16, weight: .bold)
                                    .frame(width: 200, height: 50)
                                    .background(!skinType.isEmpty && !selectedConcerns.isEmpty ? Color.chanelBlack : Color.gray)
                                    .foregroundColor(.white)
                            }
                            .disabled(skinType.isEmpty || selectedConcerns.isEmpty)
                            .padding(.vertical, 30)
                            
                            Spacer()
                        }
                        .background(Color.chanelCream)
                        .tag("quiz")
                        .tabItem {
                            Label("Quiz", systemImage: "questionmark.circle")
                                .environment(\.symbolVariants, .none)
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    currentScreen = "home"
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                        Text("Home")
                                    }
                                    .foregroundColor(.chanelGold)
                                }
                            }
                        }
                        
                        // Saved Routines Screen
                        VStack {
                            Text("Saved Routines")
                                .chanelFont(size: 28, weight: .bold)
                                .foregroundColor(.chanelBlack)
                                .padding()
                            
                            if savedRoutines.isEmpty {
                                VStack {
                                    Spacer()
                                    Text("No saved routines")
                                        .chanelFont(size: 18)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            } else {
                                List {
                                    ForEach(savedRoutines) { routine in
                                        NavigationLink(
                                            destination: RoutineDetailView(routine: routine)
                                        ) {
                                            Text(routine.name)
                                                .chanelFont(size: 18)
                                                .foregroundColor(.chanelBlack)
                                                .padding(.vertical, 8)
                                        }
                                        .listRowBackground(Color.white)
                                    }
                                    .onDelete { indexSet in
                                        savedRoutines.remove(atOffsets: indexSet)
                                        saveRoutines()
                                    }
                                }
                                .listStyle(.plain)
                                .background(Color.chanelCream)
                            }
                            
                            Spacer()
                        }
                        .background(Color.chanelCream)
                        .tag("saved")
                        .tabItem {
                            Label("Saved", systemImage: "folder")
                                .environment(\.symbolVariants, .none)
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    currentScreen = "quiz"  // Changed from "home" to "quiz"
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                        Text("Quiz")  // Changed from "Home" to "Quiz"
                                    }
                                    .foregroundColor(.chanelGold)
                                }
                            }
                        }
                    }
                    .tint(.chanelBlack)
                    .onAppear {
                        UITabBar.appearance().backgroundColor = UIColor.white
                        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
                    }
                }
            }
        }
        .accentColor(.chanelBlack)
        .onAppear {
            loadRoutines()
        }
    }
    
    // Generate routine based on skin type and multiple concerns
    private func generateRoutine(skinType: String, concerns: [String]) -> [String] {
        let routines: [String: [String: [String]]] = [
            "oily": [
                "acne": ["Cleanser: Salicylic Acid Wash", "Toner: Witch Hazel", "Moisturizer: Oil-Free Gel", "Treatment: Benzoyl Peroxide"],
                "dryness": ["Cleanser: Gentle Foam", "Toner: Hydrating Mist", "Moisturizer: Lightweight Cream", "Treatment: Niacinamide Serum"],
                "aging": ["Cleanser: Gentle Foam", "Toner: Rose Water", "Moisturizer: Anti-Aging Cream", "Treatment: Retinol Serum"],
                "wrinkles": ["Cleanser: Micellar Water", "Toner: Hydrating Mist", "Moisturizer: Anti-Wrinkle Cream", "Treatment: Peptide Serum"],
                "hyperpigmentation": ["Cleanser: Salicylic Acid Wash", "Toner: Green Tea", "Moisturizer: Oil-Free Gel", "Treatment: Vitamin C Serum"],
                "dullness": ["Cleanser: Gentle Foam", "Toner: Exfoliating Toner", "Moisturizer: Lightweight Cream", "Treatment: Glycolic Acid Serum"],
                "sun damage": ["Cleanser: Gentle Foam", "Toner: Rose Water", "Moisturizer: SPF Cream", "Treatment: Antioxidant Serum"],
                "others": ["Cleanser: Basic Wash", "Toner: Basic Toner", "Moisturizer: Basic Cream", "Treatment: Basic Serum"]
            ],
            "dry": [
                "acne": ["Cleanser: Creamy Wash", "Toner: Rose Water", "Moisturizer: Rich Cream", "Treatment: Retinol Serum"],
                "dryness": ["Cleanser: Micellar Water", "Toner: Hyaluronic Acid", "Moisturizer: Heavy Cream", "Treatment: Ceramide Serum"],
                "aging": ["Cleanser: Creamy Wash", "Toner: Rose Water", "Moisturizer: Anti-Aging Cream", "Treatment: Retinol Serum"],
                "wrinkles": ["Cleanser: Micellar Water", "Toner: Hyaluronic Acid", "Moisturizer: Anti-Wrinkle Cream", "Treatment: Peptide Serum"],
                "hyperpigmentation": ["Cleanser: Creamy Wash", "Toner: Rose Water", "Moisturizer: Rich Cream", "Treatment: Vitamin C Serum"],
                "dullness": ["Cleanser: Micellar Water", "Toner: Exfoliating Toner", "Moisturizer: Heavy Cream", "Treatment: Glycolic Acid Serum"],
                "sun damage": ["Cleanser: Creamy Wash", "Toner: Rose Water", "Moisturizer: SPF Cream", "Treatment: Antioxidant Serum"],
                "others": ["Cleanser: Basic Wash", "Toner: Basic Toner", "Moisturizer: Basic Cream", "Treatment: Basic Serum"]
            ],
            "combination": [
                "acne": ["Cleanser: Gel Wash", "Toner: Green Tea", "Moisturizer: Light Lotion", "Treatment: Tea Tree Oil"],
                "dryness": ["Cleanser: Milky Cleanser", "Toner: Aloe Vera", "Moisturizer: Balanced Cream", "Treatment: Vitamin C Serum"],
                "aging": ["Cleanser: Gel Wash", "Toner: Green Tea", "Moisturizer: Anti-Aging Cream", "Treatment: Retinol Serum"],
                "wrinkles": ["Cleanser: Milky Cleanser", "Toner: Aloe Vera", "Moisturizer: Anti-Wrinkle Cream", "Treatment: Peptide Serum"],
                "hyperpigmentation": ["Cleanser: Gel Wash", "Toner: Green Tea", "Moisturizer: Light Lotion", "Treatment: Vitamin C Serum"],
                "dullness": ["Cleanser: Milky Cleanser", "Toner: Exfoliating Toner", "Moisturizer: Balanced Cream", "Treatment: Glycolic Acid Serum"],
                "sun damage": ["Cleanser: Gel Wash", "Toner: Green Tea", "Moisturizer: SPF Cream", "Treatment: Antioxidant Serum"],
                "others": ["Cleanser: Basic Wash", "Toner: Basic Toner", "Moisturizer: Basic Cream", "Treatment: Basic Serum"]
            ]
        ]
        
        var combinedRoutine: [String] = []
        for concern in concerns {
            if let routine = routines[skinType]?[concern] {
                combinedRoutine.append(contentsOf: routine)
            }
        }
        
        // Remove duplicates while preserving order
        var uniqueRoutine: [String] = []
        var seenProducts: Set<String> = []
        for product in combinedRoutine {
            if !seenProducts.contains(product) {
                uniqueRoutine.append(product)
                seenProducts.insert(product)
            }
        }
        
        return uniqueRoutine.isEmpty ? ["Cleanser: Basic Wash", "Toner: Basic Toner", "Moisturizer: Basic Cream"] : uniqueRoutine
    }
    
    // Save routines to UserDefaults
    private func saveRoutines() {
        if let data = try? JSONEncoder().encode(savedRoutines) {
            UserDefaults.standard.set(data, forKey: "savedRoutines")
        }
    }
    
    // Load routines from UserDefaults
    private func loadRoutines() {
        if let data = UserDefaults.standard.data(forKey: "savedRoutines"),
           let routines = try? JSONDecoder().decode([Routine].self, from: data) {
            savedRoutines = routines
        }
    }
}

#Preview {
    ContentView()
}
