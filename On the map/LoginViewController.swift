//
//  ViewController.swift
//  On the map
//
//  Created by Jessie Hon on 2021-02-02.
//

import UIKit

class LoginViewController: UIViewController {

  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var password: UITextField!
  var userKey: String = ""
  var locations = [StudentLocation]()
  enum TabType:Int {
      case MapViewController
      case TableViewController
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    username.text = ""
    password.text = ""
  }

  @IBAction func actionLogin(_ sender: Any) {
   
    Login()
    
  }
  
  func Login() {
    let group = DispatchGroup()
    
    
    let user = username.text
    let pass = password.text
    group.enter()
    loginAsyncTask(user: user ?? "", pass: pass ?? "") {
      group.leave()
    }
    getStudentLocationsTask {
      group.leave()
    }
    /*
    DispatchQueue.global(qos: .default).async {
      UdacityAPIClient.getStudentLocations() { locations, error in
        self.locations = locations
        print("got locations")
        //group.leave()
      }
      //self.getStudentLocations()
      group.leave()
    }
    let user = username.text
    let pass = password.text
    group.enter()
    DispatchQueue.global(qos: .default).async {
      //UdacityAPIClient.login(username: self.username.text!, password: self.password.text!, completion: self.handleSessionResponse(success:error:))
      UdacityAPIClient.login(username: user ?? "", password: pass ?? "") { success, error in
        if success {
          print("successfully logged in")
          //group.leave()
        } else {
          print(error?.localizedDescription ?? "")
        }
        
      }
      group.leave()
      
    }
 */
    
    group.wait()
    print("both login and locations done")
    performSegue(withIdentifier: "toMainMenu", sender: nil)
  }
  
  func loginAsyncTask(user: String, pass: String, completionHandler: @escaping () -> Void) {
    UdacityAPIClient.login(username: user ?? "", password: pass ?? "") { success, error in
      if success {
        print("successfully logged in")
        //group.leave()
      } else {
        print(error?.localizedDescription ?? "")
      }
      
    }
  }
  
  func getStudentLocationsTask(completionHandler: @escaping () -> Void) {
    getStudentLocations()
  }
  
  func handleSessionResponse(success: Bool, error: Error?) {
    if success {
      //performSegue(withIdentifier: "toMainMenu", sender: nil)
      print("successfully logged in")
    } else {
      // show login failure
      print(error?.localizedDescription ?? "")
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let tabBarController = segue.destination as! UITabBarController
    //controller.locations = self.locations
    
    if let mapViewController =  tabBarController.viewControllers?[TabType.MapViewController.rawValue] as? MapViewController {
      mapViewController.locations = self.locations
    }
    /*
    if let mapViewController =  tabBarController.viewControllers?[TabType.MapViewController.rawValue] as? MapViewController {
      mapViewController.locations = self.locations
    }
 */
  }
 
  func getStudentLocations() {
    //UdacityAPIClient.getStudentLocations(completion: handleLoadingStudentLocations(locations: [StudentLocation], error: Error?))
    
    UdacityAPIClient.getStudentLocations() { locations, error in
      self.locations = locations
      //print(self.locations)
    }
  }
  
  
    
  func handleUserInfoResponse(success: Bool, error: Error?) {
    if success {
      //performSegue(withIdentifier: "toMainMenu", sender: nil)
      print("getting info success")
    } else {
      // show login failure
      print("getting info error")
      print(error?.localizedDescription ?? "")
    }
  }
  
  func handleLoadingStudentLocations(locations: [StudentLocation], error: Error?) {
    if error == nil {
      //performSegue(withIdentifier: "toMainMenu", sender: nil)
      print("adding annotations success")
      //addStudentLocations()
    } else {
      // show login failure
      print("getting student locations error")
      print(error?.localizedDescription ?? "")
    }
  }
}

