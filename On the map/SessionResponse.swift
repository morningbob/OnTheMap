//
//  SessionResponse.swift
//  On the map
//
//  Created by Jessie Hon on 2021-02-03.
//

import Foundation

struct SessionResponse: Codable {
  
  let account: Account
  let session: Session
}

struct Account: Codable {
  
  let registered: Bool
  let key: String
}

struct Session: Codable {
  let id: String
  let expiration: String
}
/*
extension SessionResponse: LocalizedError {
    var errorDescription: String? {
        return session
    }
}
 */
