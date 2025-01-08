//
//  ResponseModel.swift
//  Gogo
//
//  Created by Xian Yin on 12/27/24.
//


struct ResponseModel<T: Codable>: Codable {
    let code: ResponseEnum
    let msg: String
    let data: T?
}
