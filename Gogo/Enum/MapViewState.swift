//
//  MapViewState.swift
//  GogoStudy
//
//  Created by Xian Yin on 12/31/24.
//

import Foundation

enum MapViewState {
    // 没有搜索
    case noInput
    
    //搜索地址列表页面
    case searchingForLocation
    
    //已选择位置
    case locationSelected
    
    //导航线已经添加
    case polylineAdded
}
