//
//  LocationsResponse.swift
//  On the map
//
//  Created by Jessie Hon on 2021-02-05.
//

import Foundation

struct LocationsResponse : Codable {
  
  let locations: [StudentLocation]
  
  enum CodingKeys: String, CodingKey {
    case locations = "results"
  }
}
