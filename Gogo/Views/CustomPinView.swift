//
//  CustomPinView.swift
//  Gogo
//
//  Created by Xian Yin on 1/6/25.
//

import SwiftUI

struct CustomPinView: View {
    @State var address: String // 传入显示的地址
    @State var description: String = "上车点:" // 传入说明文字

    var body: some View {
        VStack(spacing: 5) {
            // 气泡框视图
            VStack(alignment: .leading, spacing: 5) {
                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .padding(.top, 5)

                Text(address)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .bold()
                    .lineLimit(1)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 5)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.8), Color.black.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)

            // 图钉
            ZStack {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 16, height: 16) // 图钉主体
                    .shadow(color: Color.orange.opacity(0.5), radius: 5, x: 0, y: 2)

                Circle()
                    .stroke(Color.white, lineWidth: 1)
                    .frame(width: 20, height: 20) // 白色边框
                
                Rectangle()
                    .frame(width: 2, height: 8)
                    .padding(.top, 28)
                
            }
        }
        .frame(maxWidth: 200) // 限制宽度，避免内容过长
    }
}

#Preview {
    CustomPinView(address: "1111111111")
}
