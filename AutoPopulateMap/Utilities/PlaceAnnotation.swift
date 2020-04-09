//
//  PlaceAnnotation.swift
//  AutoPopulateMap
//
//  Created by Jon Corn on 4/7/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
  
  @objc dynamic var coordinate: CLLocationCoordinate2D
  
  var title: String?
  var url: URL?
  
  init(coordinate: CLLocationCoordinate2D) {
      self.coordinate = coordinate
      super.init()
  }
}
