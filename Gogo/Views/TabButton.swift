//
//  TabButton.swift
//  Slide_Menu
//
//  Created by Xian Yin on 12/31/24.
//

import SwiftUI

struct TabButton: View {
    var title: String
    var image: String
    
    @Binding var seletedTab: String
    var animation: Namespace.ID
    
    var body: some View {
        Button(action:{
            withAnimation(.spring) {
                seletedTab = title
            }
        }){
            HStack(spacing: 10){
                Image(systemName: image)
                    .font(.title2)
                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundColor(seletedTab == title ? Color.blue : .white)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                ZStack{
                    if seletedTab == title {
                        Color.white
                            .opacity(seletedTab == title ? 1 : 0)
                            .clipShape(CustomShape(corners: [.topRight, .bottomRight], radius: 10))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                 }
            )
        }

    }
}

#Preview {
    ContentView()
}
