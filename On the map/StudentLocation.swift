//
//  StudentLocation.swift
//  On the map
//
//  Created by Jessie Hon on 2021-02-05.
//

import Foundation

struct StudentLocation : Codable {
  let firstName: String
  let lastName: String
  let longitude: Double
  let latitude: Double
  let mapString: String
  let mediaURL: String
  let uniqueKey: String
  let objectId: String
  
}
