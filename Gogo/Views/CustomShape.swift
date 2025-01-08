//
//  CustomShape.swift
//  Slide_Menu
//
//  Created by Xian Yin on 12/31/24.
//

import SwiftUI

struct CustomShape: Shape { // 定义一个遵循 SwiftUI Shape 协议的结构体
    var corners: UIRectCorner  // 指定需要圆角的具体角，比如 .topLeft、.bottomRight 等
    var radius: CGFloat        // 定义圆角的半径，用于控制圆角的弧度大小

    // Shape 协议要求实现的方法，用于定义形状的路径
    func path(in rect: CGRect) -> Path {
        // 使用 UIBezierPath 创建一个带有指定圆角的矩形路径
        let path = UIBezierPath(
            roundedRect: rect,                         // 定义矩形的大小和位置
            byRoundingCorners: corners,               // 指定需要圆角的具体角
            cornerRadii: CGSize(width: radius, height: radius) // 定义圆角半径
        )

        // 将 UIBezierPath 转换为 SwiftUI 的 Path 并返回
        return Path(path.cgPath)
    }
}

#Preview {
    CustomShape(corners: UIRectCorner(), radius: 10)
}
