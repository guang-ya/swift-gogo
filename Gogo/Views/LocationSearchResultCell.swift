//
//  LocationSearchResultCell.swift
//  GogoStudy
//
//  Created by Xian Yin on 12/29/24.
//

import SwiftUI

struct LocationSearchResultCell: View {
    let title: String
    let subtitle: String
    
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundStyle(.blue)
                .tint(.white)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4){
                Text(title)
                    .font(.body)
                
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
                
                Divider()
            }
            .padding(.leading)
        }
        .padding(.leading)
        .padding(.vertical, 8)
    }
}

#Preview {
    LocationSearchResultCell(title: "Starbucks coffee", subtitle: "12332132")
}
