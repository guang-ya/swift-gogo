//
//  ProfileHeaderView.swift
//  Gogo
//
//  Created by Xian Yin on 1/6/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    // 输入参数，支持动态配置
    var profileImage: Image
    var username: String
    var location: String

    var body: some View {
        HStack(spacing: 12) {
            // 用户头像
            profileImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50) // 设置头像尺寸
                .clipShape(Circle()) // 圆形裁剪
                .overlay(
                    Circle()
                        .stroke(Color.gray, lineWidth: 1) // 添加边框
                )
            
            // 用户名和位置信息
            VStack(alignment: .leading, spacing: 4) {
                // 显示用户名
                Text(username)
                    .font(.headline) // 设置字体样式
                    .foregroundColor(.primary) // 主字体颜色
                
                // 显示位置信息
                HStack(spacing: 4) {
                    Image(systemName: "location.fill") // 定位图标
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12) // 图标尺寸
                        .foregroundColor(.gray) // 图标颜色
                    
                    Text(location)
                        .font(.subheadline)
                        .foregroundColor(.gray) // 文字颜色
                        .lineLimit(1) // 限制单行显示
                }
            }
        }
        .padding() // 设置内边距
        .background(Color.white) // 设置背景色
        .cornerRadius(10) // 圆角背景
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2) // 添加阴影效果
    }
}

#Preview {
    ProfileHeaderView(profileImage: Image("IMG_0057_sm"), username: "diandian", location: "")
}
