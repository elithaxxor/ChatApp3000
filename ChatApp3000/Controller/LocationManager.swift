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

class CLLocationButton : UIControl {

    

}

class LocationDataManager : NSObject, CLLocationManagerDelegate {
   var locationManager = CLLocationManager()

   override init() {
      super.init()
      locationManager.delegate = self
   }

   // Location-related properties and delegate methods.
}
