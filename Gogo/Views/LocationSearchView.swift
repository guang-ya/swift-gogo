//
//  LocationSearchView.swift
//  GogoStudy
//
//  Created by Xian Yin on 12/29/24.
//

import SwiftUI

struct LocationSearchView: View {
    
    @Binding var mapState: MapViewState
    @State private var slt = ""
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    @Binding var pickupAddress: String
    @Binding var dropoffAddress: String
    
    var body: some View {
        VStack {
            //  header view
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.blue))
                        .frame(width: 6, height: 6)
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(width: 1, height: 24)
                    Circle()
                        .fill(Color(.green))
                        .frame(width: 6, height: 6)
                }
                
                VStack {
                    TextField(pickupAddress, text: $slt)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    TextField("Where go?", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
            }
            .padding(.horizontal)
            .padding(.top, 52)
            
            Divider().padding(.vertical)
            
            //list view
            ScrollView{
                VStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { result in
                        LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring) {
                                    viewModel.selectLocation(result)
                                    mapState = .locationSelected
                                }
                            }
                    }
                }
            }
        }
        .background(Color.theme.backgroundColor)
        .background(.white)
    }
}

#Preview {
    LocationSearchView(mapState: .constant(.noInput),pickupAddress: .constant(""),dropoffAddress: .constant(""))
        .environmentObject(LocationSearchViewModel()) // 注入环境对象
}
