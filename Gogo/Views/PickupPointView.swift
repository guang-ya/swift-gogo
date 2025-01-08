//
//  PickupPointView.swift
//  Gogo
//
//  Created by Xian Yin on 1/6/25.
//

import SwiftUI

// PickupPointView 封装
struct PickupPointView: View {
    
    var title: String
    @Binding var pickupAddress: String
    
    var onSelect: (_ title: String,_ pickupAddress: String) -> Void // 点击回调
    
    var body: some View {
        // 列表
        Button(action: {
            onSelect(title, pickupAddress) // 触发回调
        }) {
            HStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 10) // 蓝色圆点
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(self.title)
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Text(self.pickupAddress)
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
    PickupPointView(title: "越秀财富世纪广场", pickupAddress: .constant("1111111"), onSelect:{title,address in
        
    })
}
