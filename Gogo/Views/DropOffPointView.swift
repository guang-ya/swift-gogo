//
//  PickupPointView.swift
//  Gogo
//
//  Created by Xian Yin on 1/6/25.
//

import SwiftUI


struct DropOffPointView: View {
    
    var title: String
    @Binding var dropoffAddress: String
    
    var onSelect: (_ title: String,_ dropoffAddress: String) -> Void // 点击回调
    
    var body: some View {
        // 列表
        Button(action: {
            onSelect(title, dropoffAddress) // 触发回调
        }) {
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(self.title)
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Text(self.dropoffAddress)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 5)
                
                Spacer()
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    DropOffPointView(title: "越秀财富世纪广场", dropoffAddress: .constant("00000000"), onSelect:{title,address in
        
    })
}
