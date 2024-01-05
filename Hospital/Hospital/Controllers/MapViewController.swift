//
//  MapViewController.swift
//  Hospital
//
//  Created by Shannu on 11/03/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController , CLLocationManagerDelegate , MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    //IBOutlet var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var userLat : Double!
    var userLon : Double!
    var destLat : Double!
    var destLon : Double!
    var destCor : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(destLat)
        print(destLon)

        mapView.delegate = self
        destCor = CLLocationCoordinate2DMake(destLat, destLon)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.mapDes(desPlace: self.destCor)
        })
        
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            userLat = location.coordinate.latitude
            userLon = location.coordinate.longitude
        }
    }
    
    func mapDes(desPlace : CLLocationCoordinate2D){
        
        let userLoc = (locationManager.location?.coordinate)!
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLoc
        annotation.title = "Your Location"
        mapView.addAnnotation(annotation)
        
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = destCor
        annotation1.title = "Patient's Location"
        mapView.addAnnotation(annotation1)
        
        let userPlcemark = MKPlacemark(coordinate: userLoc)
        let destPlacemark = MKPlacemark(coordinate: desPlace)
        
        let srcItem = MKMapItem(placemark: userPlcemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = srcItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if error != nil {
                    print("Something is wrong :(")
                }
                return
            }
            
          let route = response.routes[0]
        
          self.mapView.addOverlay(route.polyline)
          self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }

}
