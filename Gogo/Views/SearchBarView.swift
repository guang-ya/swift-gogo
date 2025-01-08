//
//  SearchBarView.swift
//  Gogo
//
//  Created by Xian Yin on 12/28/24.
//
import SwiftUI

struct SearchBarView: View {
    // onSearch 闭包接受两个字符串参数：start 和 end
    let onSearch: (String, String) -> Void

    @State private var startLocation = ""
    @State private var endLocation = ""

    var body: some View {
        VStack {
            TextField("Enter start location", text: $startLocation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Enter end location", text: $endLocation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                // 调用 onSearch 闭包并传递起点和终点
                onSearch(startLocation, endLocation)
            }) {
                Text("Search")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    SearchBarView(onSearch: {keyword, filter in
        print("搜索关键字: \(keyword)")
        print("筛选条件: \(filter)")
    })
}

