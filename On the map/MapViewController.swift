//
//  TabBarViewController.swift
//  On the map
//
//  Created by Jessie Hon on 2021-02-02.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UITabBarDelegate {
  
  var annotations = [MKPointAnnotation]()
  var locations = [StudentLocation]()

  @IBOutlet weak var mapView: MKMapView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //print(String(data: data!, encoding: .utf8)!)
    mapView.delegate = self
    print("locations in mapVC")
    print(locations.count)
    addStudentLocations()
    // center map location
    //self.mapView.setCenter(pin.coordinate, animated: true)
    //let region = MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    //self.mapView.setRegion(region, animated: true)
    
    //let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    
    // create annotations from student locations

  }
  
  func getUserInfo() {
    UdacityAPIClient.getUserInfo(completion: handleUserInfoResponse(success:error:))
  }
  /*
  func getStudentLocations() {
    locations = UdacityAPIClient.getStudentLocations(completion: handleUserInfoResponse(success:error:))!
  }
 */
    
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
  /*
  func handleLoadingStudentLocations(success: Bool, error: Error?) {
    if success {
      //performSegue(withIdentifier: "toMainMenu", sender: nil)
      print("adding annotations success")
      addStudentLocations()
    } else {
      // show login failure
      print("getting student locations error")
      print(error?.localizedDescription ?? "")
    }
  }
 */
  
  // This delegate method is implemented to respond to taps. It opens the system browser
   // to the URL specified in the annotationViews subtitle property.
 func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
     if control == view.rightCalloutAccessoryView {
         let app = UIApplication.shared
         if let toOpen = view.annotation?.subtitle! {
             app.openURL(URL(string: toOpen)!)
         }
     }
 }
  
  func addStudentLocations() {
    for student in locations {
      let lat = CLLocationDegrees(student.latitude as! Double)
      let long = CLLocationDegrees(student.longitude as! Double)
      
      let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
      
      let firstName = student.firstName
      let lastName = student.lastName
      let mediaURL = student.mediaURL
      
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      annotation.title = "\(firstName) \(lastName)"
      annotation.subtitle = mediaURL
      
      annotations.append(annotation)
    }
    
    mapView.addAnnotations(annotations)
  }
  
  // Here we create a view with a "right callout accessory view". You might choose to look into other
   // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
   // method in TableViewDataSource.
  /*
 func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     
     let reuseId = "pin"
     
     var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

     if pinView == nil {
         pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
         pinView!.canShowCallout = true
         pinView!.pinTintColor = .green
         pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
     }
     else {
         pinView!.annotation = annotation
     }
     
     return pinView
 }
 */
}
