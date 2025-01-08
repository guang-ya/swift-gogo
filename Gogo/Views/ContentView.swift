//
//  ContentView.swift
//  Slide_Menu
//
//  Created by Xian Yin on 12/31/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @EnvironmentObject var viewModel: LocationSearchViewModel

    var body: some View {
        MainView()
            .environmentObject(viewModel)
    }

}

#Preview {
    ContentView()
        .environmentObject(LocationSearchViewModel())
}
