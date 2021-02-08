//
//  UserInfoResponse.swift
//  On the map
//
//  Created by Jessie Hon on 2021-02-05.
//

import Foundation

struct UserInfoResponse: Codable {
  let first_name: String
  let last_name: String
  let key: String
}
/*
struct UserInfoResponse1: Codable {
  
  let last_name: String
  let social_accounts: [String]
  let mailing_address: String?
  let _cohort_keys: [String]
  let signature: String?
  let _stripe_customer_id: String?
  let `guard`: [String]
  let _facebook_id: String?
  let timezone: String?
  let site_preferences: String?
  let occupation: String?
  let _image: String?
  let first_name: String
  let jabber_id: String?
  let languages: String?
  let _badges: [String]
  let location: String?
  let external_service_password: String?
  let _principals: [String]
  let _enrollments: [String]
  let email: Email
  let website_url: String?
  let external_accounts: [String]
  let bio: String?
  let coaching_data: String?
  let tags: [String]
  let _affiliate_profiles: [String]
  let _has_password: Bool
  let email_preferences: String?
  let _resume: String?
  let key: String
  let nickname: String
  let employer_sharing: Bool
  let _memberships: [String]
  let zendesk_id: String?
  let _registered: Bool
  let linkedin_url: String?
  let _google_id: String?
  let _image_url: String?
  

}

struct Email : Codable {
  let address: String
  let isVerified: Bool
  let isVerificationCodeSent: Bool
  
  enum CodingKeys: String, CodingKey {
    case address
    case isVerified = "_verified"
    case isVerificationCodeSent = "_verification_code_sent"
  }
}
 */
