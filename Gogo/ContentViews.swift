//
//  ContentViews.swift
//  Gogo
//
//  Created by Xian Yin on 12/28/24.
//

import SwiftUI

struct ContentViews: View {
    @State private var showError = false // 控制提示框显示状态

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Password Error Example")
                    .font(.title)
                    .padding()

                Button(action: {
                    showErrorMessage()
                }) {
                    Text("Show Error")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

            // 自定义提示框
            if showError {
                VStack {
                    Text("Incorrect Password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                }
                .transition(.opacity) // 淡入淡出动画
                .zIndex(1) // 确保提示框在最上层
            }
        }
    }

    // 显示错误提示并自动消失
    private func showErrorMessage() {
        withAnimation {
            showError = true
        }

        // 2秒后隐藏提示框
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showError = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
