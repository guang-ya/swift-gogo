//
//  Home.swift
//  Slide_Menu
//
//  Created by Xian Yin on 12/31/24.
//

import SwiftUI

struct Home: View {
    
    @Binding var selectedTab: String
    @Binding var showMenu: Bool
    
    init(selectedTab: Binding<String>, showMenu: Binding<Bool>) {
        self._selectedTab = selectedTab
        self._showMenu = showMenu
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CarOwnerHomePage()
                .tag("车主主页")
                .onTapGesture {
                    showMenu.toggle()
                }
            PassengerHomePage()
                .tag("乘客主页")
                .onTapGesture {
                    showMenu.toggle()
                }
            History()
                .tag("历史")
            Notifications()
                .tag("通知")
            Setting()
                .tag("设置")
            Help()
                .tag("帮助")
        }
    }
}

struct History: View {
    var body: some View {
        NavigationView{
            Text("历史")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("历史")
        }
    }
}
struct Notifications: View {
    var body: some View {
        NavigationView{
            Text("通知")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("通知")
        }
    }
}
struct Setting: View {
    var body: some View {
        NavigationView{
            Text("设置")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("设置")
        }
    }
}
struct Help: View {
    var body: some View {
        NavigationView{
            Text("帮助")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("帮助")
        }
    }
}

#Preview {
    Home(selectedTab: .constant("主页"), showMenu: .constant(true))
        .environmentObject(LocationSearchViewModel())
}
