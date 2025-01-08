//
//  MapViewActionButton.swift
//  GogoStudy
//
//  Created by Xian Yin on 12/29/24.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        Button{
            withAnimation(.spring) {
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundStyle(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func actionForState(_ state: MapViewState){
        switch state {
        case .noInput:
            mapState = .searchingForLocation
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected,.polylineAdded:
            mapState = .noInput
            //解决第一次导航后，再进行第二次导航的时候，还保留着上一次导航的路线的问题
            viewModel.selectedDestinationLocation = nil
        }
    }
    
    func imageNameForState(_ state: MapViewState) -> String{
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation:
            return "arrow.left"
        case .locationSelected, .polylineAdded:
            return "arrow.left"
        }
    }
}

#Preview {
    MapViewActionButton(mapState: .constant(.noInput))
}
