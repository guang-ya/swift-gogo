//
//  GogoApp.swift
//  Gogo
//
//  Created by Xian Yin on 12/26/24.
//

import SwiftUI
import SwiftData

@main
struct GogoApp: App {
    
    @StateObject var locationViewModel = LocationSearchViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(locationViewModel)
//            CarOwnerHomePage()
//                .environmentObject(locationViewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
