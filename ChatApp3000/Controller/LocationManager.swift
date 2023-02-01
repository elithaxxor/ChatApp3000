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
import MapKit


// TODO:
// 1. Create UIButton() and when tapped, call getDirections()
// 2. Save directions in UserDefaults
//

/// add this:
// https://developer.apple.com/documentation/mapkit/mkusertrackingbutton

class LocationDataManager : NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    let regionInMeters : Double = 10000
    var previousLocation : CLLocation?
    
    let geoCoder = CLGeocoder()
    var directionsArr : [MKDirections] = []
    
    
    let mapView : MKMapView = {
        let map = MKMapView()
        print("[!] Creating mapview.. ")
        map.overrideUserInterfaceStyle = .dark
        map.addSubview(UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100)))
        return map
    }()
    
    
    /// NOTE: Start Up CLLocation Manager
    func isServiceRunning() { // boolean value if location services are running
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            verifyLocationAuthorization()
        } else {
            /// pull up alert
        }
    }
    
    // TODO: ADD ALERTS
    func verifyServices() { // helper function for isServiceRunning()
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation() // segues to next function--> get user location
        case .denied
            print("Locatin manager denied. ")
            break
            
        case .notDetermined
            print("authorization not determined, running requestWhenInUse ")
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("user has settings to restricted authorization ")
            
            break
            
        case .authorizedAlways:
            print("user has settings to always authorized  ")
            break
        }
    }
    
    
    func setupLocationManager() {
        return
    }
    
    
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    // helper method to determine the initial longitude and latitude
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        lat latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        print("[!] returning center location \(latitude)\(longitude)")
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    
    /// NOTE: Start of directions
    // 1
    //  getDirections serves as the start of locationManager requests
    // https://developer.apple.com/documentation/mapkit/mkdirections/1452197-init
    
    // helper function, clears the mapView on run and call--> empties out directions
    func resetMapView(withNew directions : MKDirections) {
        mapView.removeOverlay(mapView.overlays)
        directionsArr.append(directions)
        let _ = directionsArr.map { $0.cancel() }
    }
    
    
    
    
    func getDirections() {
        guard let location = locationManager.location?.coordinate else {
            print("no location available ")
            return
        }
        let request = createDirectionsRequest(location)
        let directions = MKDirections(request: request) // sends call to MKDirection API
        resetMapView(withNew: directions)
        
        
        directions.calculate{ [unowned self] (response, error) in
            guard let response = response else { return }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    // creates destination and source for function oabove ^
    // grabs the center of the map as the first lcoation
    // 2
    func createDirectionsRequest(location) -> MKDirections.request {
        let startingLocation = MKPlacemark(coordinate: coordinate) // user location
        let destinatinoCoordiante = getCenterLocation(for: mapView).coordinate // grabs center location to fulfil destination paramater
        let destination = MKPlacemark(coordinate: destinatinoCoordiante ) // location to travel to
        
        
        // create request to MKMap API using vars ^ as params
        let request = MKDirections.Request()
        request.source = MKMapItem
        request.destination = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
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
    
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        let m = manager
        print(manager)
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let m = manager
        print(manager.authorizationStatus)
    }
    
    override init() {
        super.init()
        
        
        // self.longitude = .none
        //self.latitude = .none
        let delegate = CLLocationManagerDelegate.self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = .greatestFiniteMagnitude
        let backGroundIndicator = locationManager.allowsBackgroundLocationUpdates
        
        self.getDirections()
        
        
        self.updateLocation()
        self.monitorVisits()
        //  self.islocationServicesEnabled()
        self.findLocation()
    }
    
    func findLocation() {
        let location = locationManager.location
        let authorizationStatus = locationManager.authorizationStatus
        
        print("[!] Current Authortization status \(authorizationStatus)")
        print("[!] Current Location  \(location)")
        
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            print("[!] Requesting Authorization Status ")
            print("[?] Updated Authortization status \(authorizationStatus)")
            
        }
        else if authorizationStatus == .denied || authorizationStatus == .restricted {
            print("[-] Denied Authorization Status \(authorizationStatus)")
            reportLocationServicesDeniedError()
            return
        }
        
    }
    
    private func updateLocation() {
        self.locationManager.allowsBackgroundLocationUpdates = true
        //  locationManager.delegate = self
        isUpdatingLocation = true
        locationManager.activityType = .automotiveNavigation
        locationManager.startUpdatingLocation() // STARTS LOCATION UPDATE AUTOMATICALLY -->
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
    
    func monitorVisits() {
        locationManager.startMonitoringVisits()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay : MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
        
    }
}

extension LocationDataManager : CLLocationManagerDelegate {
    
    
}

extension LocationDataManager : MKMapViewDelegate {
    
    
    // Tells the delegate when the region the map view is displaying changes.
    func mapView(_ mapView: MKMapView, regionDidChange animated: Bool) {
        let center = getCenterLocation(for: mapView)
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.cancelGeocode()
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                // TODO: Create alert
                return
            }
        https://intellipaat.com/blog/interview-question/ios-interview-questions/

            guard let response = placemarks?.first else {
                // TODO: Create alert
                return
            }
            
            let streetNumber = response.subThoroughfare ?? ""
            let streetName = response.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber)\(streetName)"
            }
            
  
        }
    }
}



