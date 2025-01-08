//
//  MainView.swift
//  Slide_Menu
//
//  Created by Xian Yin on 12/31/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    @State private var passengerOrDriver = PassengerOrDriver.passenger
    
    @State var selectedTab = "乘客主页"
    @State var showMenu = false
    @Namespace var animation
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            if passengerOrDriver == .passenger {
                PassengerSlideMenu(selectedTab: $selectedTab,
                                   showMenu: $showMenu,
                                   passengerOrDriver: $passengerOrDriver,
                                   animation: _animation)
                .transition(.move(edge: .leading))
            }else if passengerOrDriver == .driver {
                DriverSlideMenu(passengerOrDriver: $passengerOrDriver,
                                showMenu: $showMenu,
                                selectedTab: $selectedTab,
                                animation: _animation)
                .transition(.move(edge: .leading))
            }
            
            
            ZStack {
                Home(selectedTab: $selectedTab, showMenu: $showMenu)
                    .cornerRadius(showMenu ? 15 : 0)
            }
            .scaleEffect(showMenu ? 0.85 : 1)
            .offset(x: showMenu ? getRect().width - 150 : 0)
            .ignoresSafeArea()
            .overlay(
                Button(action: {
                    withAnimation(.spring) {
                        showMenu.toggle()
                    }
                }){
                    ///做成动画
                    VStack {
                        Capsule()
                            .fill(showMenu ? Color.white : Color.primary)
                            .frame(width: 30, height: 3)
                            .rotationEffect(.init(degrees: showMenu ? -50: 0))
                            .offset(x: showMenu ? 2 : 0, y: showMenu ? 12 :0)
                        VStack(spacing: 5) {
                            Capsule()
                                .fill(showMenu ? Color.white : Color.primary)
                                .frame(width: 30, height: 3)
                            Capsule()
                                .fill(showMenu ? Color.white : Color.primary)
                                .frame(width: 30, height: 3)
                                .offset(y: showMenu ? -8 :0)
                        }
                        .rotationEffect(.init(degrees: showMenu ? 50 : 0))
                    }
                }
                .padding()
                ,alignment: .topLeading
            )
        }
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

#Preview {
    MainView()
}
