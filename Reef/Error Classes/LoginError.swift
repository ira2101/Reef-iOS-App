//
//  LoginError.swift
//  Reef
//
//  Created by Ira Einbinder on 1/24/22.
//

import Foundation

enum LoginError : Error {
    case loginFailed(localizedDescription : String)
    case userAlreadyExists
    case userNotLoggedIn
    case unexpected(code : Int)
}
