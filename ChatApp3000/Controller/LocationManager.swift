//
//  LocationManager.swift
//  ChatApp3000
//
//  Created by Adel Al-Aali on 1/30/23.
//

import Foundation
import UIKit
import CoreLocation
import CoreLocationUI

class LocationDataManager : NSObject, CLLocationManagerDelegate {
   
    var locationManager = CLLocationManager()
    
    let location = CLLocation()
    func locationConfig() {
        return
    }
    
   
    var kCLLocationAccuracyBestForNavigation: CLLocationAccuracy? // LOCATION ACCURACY

    // SETUP
    var isAuthorizedForWidgetUpdates: Bool?
    var accuracyAuthorization: CLAccuracyAuthorization?

    class func islocationServicesEnabled() -> Bool {
        return true 
    }
    
    
    // DATA
    var altitude: CLLocationDistance?
    var timestamp: Date?
    var sourceInformation: CLLocationSourceInformation?

    var isUpdatingLocation : Bool?
    var coordinate: CLLocationCoordinate2D?
    var longitude : CLLocation?
    var latitude : CLLocation?
    
    var desiredAccuracy : CLLocationAccuracy?
    var distanceFilter: CLLocationDistance?
    var kCLDistanceFilterNone: CLLocationDistance?
    
    
   override init() {
      super.init()
        
       self.kCLDistanceFilterNone = .greatestFiniteMagnitude
       self.longitude = .none
       self.latitude = .none
       
//       self.locationManager.desiredAccuracy = .greatestFiniteMagnitude
//       longitude = .none
//       latitude = .none
//
      // locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

     //  locationManager.location?.timestamp.timeIntervalSinceNow
       
       locationManager.requestAlwaysAuthorization()
       locationManager.desiredAccuracy = .greatestFiniteMagnitude
       let backGroundIndicator = locationManager.allowsBackgroundLocationUpdates
       
       self.startUpdatingLocation()
       self.startMonitoringVisits()
     //  self.islocationServicesEnabled()
       self.findLocation()
   }
    
    func findLocation() {
        let location = locationManager.location
        let authorizationStatus = locationManager.authorizationStatus
        
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            print("[!] Requesting Authorization Status ")

        }
        else if authorizationStatus == .denied || authorizationStatus == .restricted {
            print("[-] Denied Authorization Status ")
            reportLocationServicesDeniedError()
            return
        }
        
    }
    
    private func startUpdatingLocation() {
        self.locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        isUpdatingLocation = true
        locationManager.activityType = .automotiveNavigation
        self.locationManager.startUpdatingLocation() // STARTS LOCATION UPDATE AUTOMATICALLY -->

    }
    // to kill location updating
    private func stopUpdatatingLocation() {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        isUpdatingLocation = false
    }
    
    func reportLocationServicesDeniedError() {
        let alert = UIAlertController(title: "try again.. ", message: "error" , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
    }
    
    func startMonitoringVisits() {
         startMonitoringVisits()
    }
}



   // Location-related properties and delegate methods.

