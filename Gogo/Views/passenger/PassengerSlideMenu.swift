//
//  SlideMenu.swift
//  Slide_Menu
//
//  Created by Xian Yin on 12/31/24.
//

import SwiftUI

import SwiftUI

struct PassengerSlideMenu: View {
    
    @Binding var selectedTab: String
    @Binding var showMenu: Bool
    @Binding var passengerOrDriver: PassengerOrDriver
    @Namespace var animation
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            ProfileHeaderView(profileImage: Image("IMG_0057_sm"), username: "diandian", location: "3409 belmont")
            
            VStack(alignment: .leading,spacing: 15) {
                TabButton(title: "乘车记录", image: "list.bullet.rectangle", seletedTab: $selectedTab, animation: animation)
                TabButton(title: "支出", image: "dollarsign.circle", seletedTab: $selectedTab, animation: animation)
                TabButton(title: "留言", image: "bubble.left.and.bubble.right", seletedTab: $selectedTab, animation: animation)
                TabButton(title: "设置", image: "gear", seletedTab: $selectedTab, animation: animation)
                
                Button {
                    withAnimation {
                        if passengerOrDriver == .driver {
                            passengerOrDriver = .passenger
                            selectedTab = "乘客主页"
                        } else {
                            passengerOrDriver = .driver
                            selectedTab = "车主主页"
                        }
                        showMenu.toggle()
                    }
                } label: {
                    Text(passengerOrDriver == .passenger ? "切换为车主" : "切换为乘客")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.brown)
                        .cornerRadius(10)
                }
            }
            .padding(.leading, -15)
            .padding(.top, 50)
            
            Spacer()
            
            VStack (alignment: .leading, spacing: 6){
                TabButton(title: "退出登录", image: "questionmark.circle", seletedTab: .constant(""), animation: animation)
                    .padding(.leading, -15)
                Text("App version： 1.2.34")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .opacity(0.7)
                    .foregroundColor(.white)
            }
        })
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}


#Preview {
    PassengerSlideMenu(selectedTab: .constant("主页"), showMenu: .constant(true), passengerOrDriver: .constant(.driver))
}
