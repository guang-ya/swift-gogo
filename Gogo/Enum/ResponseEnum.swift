//
//  ResponseEnum.swift
//  Gogo
//
//  Created by Xian Yin on 12/27/24.
//


enum ResponseEnum: Int, Codable {
    // Success statuses
    case success = 200
    case created = 201
    case accepted = 202
    
    case wrongPassword = 210
    case userNotFound = 211
    case invalidCode = 212
    case incorrectCode = 213

    // Client error statuses
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case conflict = 409

    // Server error statuses
    case internalServerError = 500
    case serviceUnavailable = 503

    // Custom business statuses
    case rideNotAvailable = 600
    case paymentFailed = 601
    case driverNotFound = 602

    // 获取状态码对应的消息
    var message: String {
        switch self {
        case .success: return "Request successful"
        case .created: return "Resource created successfully"
        case .accepted: return "Request accepted"
        case .badRequest: return "Invalid request parameters"
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Access forbidden"
        case .notFound: return "Resource not found"
        case .methodNotAllowed: return "Request method not allowed"
        case .conflict: return "Resource conflict"
        case .internalServerError: return "Internal server error"
        case .serviceUnavailable: return "Service unavailable"
        case .rideNotAvailable: return "No available rides at the moment"
        case .paymentFailed: return "Payment failed"
        case .driverNotFound: return "Driver not found"
        case .wrongPassword: return "wrong password"
        case .userNotFound: return "user not found"
        case .invalidCode: return "Verification code has expired. Please request a new one."
        case .incorrectCode: return "Incorrect verification code. Please try again."
        }
    }
}
