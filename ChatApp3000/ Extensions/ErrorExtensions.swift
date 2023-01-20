//
//  ErrorExtensions.swift
//  ChatApp3000
//
//  Created by Adel Al-Aali on 1/19/23.
//

import Foundation

public enum LoginError : Error {
    case loginData
    case loginInput
}
extension LoginError {
    public var errorDescription: String {
        switch self {
        case .loginData : return "Parsing Data Error "
        case .loginInput : return "User Input Error ) "
        }
    }
}

public enum VCError : Error {
    case channelListVC
    case loginInput
}
extension VCError {
    public var errorDescription: String {
        switch self {
        case .channelListVC : return "Parsing Data Error "
        case .loginInput : return "User Input Error ) "
        }
    }
}




public enum APIError : Error {
    case tokenError
    case userNameError
}
extension APIError {
    public var errorDescription: String {
        switch self {
        case .tokenError : return "**API TOKEN ERROR "
        case .userNameError : return "**API USER ERROR ) "
        }
    }
}


