//
//  UdacityAPIClient.swift
//  On the map
//
//  Created by Jessie Hon on 2021-02-03.
//

import Foundation

class UdacityAPIClient {
  
  struct Auth {

    static var userId = ""
    static var sessionId = ""
    static var locations : [StudentLocation]?
  }
  
  enum Endpoints {
    static let base = "https://onthemap-api.udacity.com/v1"
    
    case login
    case session
    case getStudentLocations
    case getUserInfo(String)
    
    var stringValue: String {
      switch self {
      case .login: return Endpoints.base + "/session"
      case .session: return Endpoints.base + "/session"
      case .getStudentLocations: return Endpoints.base +
        "/StudentLocation?skip=8386&limit=100&order=-updatedAt"
      case .getUserInfo(let key): return Endpoints.base + "/users/\(key)"
      }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
  }

  class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try! JSONEncoder().encode(body)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    print("before actual task")
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      print("inside task")
      guard let data = data else {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }
      let decoder = JSONDecoder()
      let range = (5..<data.count)
      let newData = data.subdata(in: range)
      do {
        print("before decoding")
        let responseObject = try decoder.decode(ResponseType.self, from: newData)
        DispatchQueue.main.async {
          completion(responseObject as! ResponseType, nil)
        }
      } catch {
        
        do {
          let errorResponse = try decoder.decode(LoginErrorResponse.self, from: newData) as! Error
          DispatchQueue.main.async {
            completion(nil, errorResponse)
          }
        } catch {
          DispatchQueue.main.async {
            completion(nil, error)
 
        print("error in decoding")
        print(error.localizedDescription)
        }
      }
      }
    }
    task.resume()
  }
  
  class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data else {
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return
        }
      let decoder = JSONDecoder()
      let range = (5..<data.count)
      let newData = data.subdata(in: range)
      print("data is back, removed first 5 characters")
      //print(String(data:newData, encoding: .utf8))
        do {
            let responseObject = try decoder.decode(UserInfoResponse.self, from: newData)
            DispatchQueue.main.async {
              completion(responseObject as! ResponseType, nil)
            }
        } catch {
            print("Can't parse newData")
            do {
              let errorResponse = try decoder.decode(LoginErrorResponse.self, from: newData) as! Error
                DispatchQueue.main.async {
                    completion(nil, errorResponse)
                }
            } catch {
              print("Error in parsing error")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    task.resume()
    
    return task
  }
  
  
  class func taskForStudentLocationsRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data else {
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return
        }
    
      let decoder = JSONDecoder()
      //let range = (5..<data.count)
      //let newData = data.subdata(in: range)
      print("StudentLocations: data is back, ")
      //print(String(data:data, encoding: .utf8))
        do {
            let responseObject = try decoder.decode(LocationsResponse.self, from: data)
            DispatchQueue.main.async {
              completion(responseObject as! ResponseType, nil)
            }
        } catch {
            print("StudentLocations: Can't parse newData")
            do {
              let errorResponse = try decoder.decode(LoginErrorResponse.self, from: data) as! Error
                DispatchQueue.main.async {
                    completion(nil, errorResponse)
                }
            } catch {
              print("Error in parsing error")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    task.resume()
    
    return task
  }
  
  
  
  class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
    let body = LoginRequest(udacity: Udacity(username: username, password: password))
    
    print("before task")
    taskForPOSTRequest(url: Endpoints.login.url, responseType: SessionResponse.self, body: body) { response, error in
      if let response = response {
        print("got response")
        Auth.userId = response.account.key
        Auth.sessionId = response.session.id
        print("userId \(Auth.userId)")
        print("sessionId \(Auth.sessionId)")
        completion(true, nil)
      } else {
        completion(false, error)
      }
      
    }
    //getStudentLocations(completion: <#T##([StudentLocation], Error?) -> Void#>)
    
  }
  
  class func getUserInfo(completion: @escaping (Bool, Error?) -> Void) {
    
    taskForGETRequest(url: Endpoints.getUserInfo(Auth.userId).url, responseType: UserInfoResponse.self) {
      response, error in
      if let response = response {
        //print(response.last_name)
        completion(true, nil)
      } else {
        completion(false, error)
      }
      
    }
  }
  
  class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) -> [StudentLocation]? {
    
    taskForStudentLocationsRequest(url: Endpoints.getStudentLocations.url, responseType: LocationsResponse.self) {
      response, error in
      if let response = response {
        Auth.locations = response.locations
        //print("locations")
        //print(Auth.locations)
        completion(response.locations, nil)
        
      } else {
        completion([], error)
      }
      
    }
    return Auth.locations
  }
  
  
  
}
