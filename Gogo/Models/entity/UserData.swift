//
//  UserData.swift
//  Gogo
//
//  Created by Xian Yin on 12/28/24.
//

import Foundation

struct UserData: Codable {
    let userId: Int64
    let username: String
    let email: String
    let phoneNumber: String
    let fullName: String?
    let address: String?
    let profilePictureUrl: String?
    let dateOfBirth: String?  // 可选值，建议格式化为字符串
    let status: String?
    let stars: Int?
    let createdAt: String?    // 建议日期格式化为 ISO8601 字符串
    let updatedAt: String?    // 建议日期格式化为 ISO8601 字符串
}
