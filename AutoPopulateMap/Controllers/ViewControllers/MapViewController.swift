//
//  MapViewController.swift
//  AutoPopulateMap
//
//  Created by Jon Corn on 4/7/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  // MARK: - Properties
  var mapItems: [MKMapItem]?
  var boundingRegion: MKCoordinateRegion?
  
  private enum AnnotationReuseID: String {
    case pin
  }
  
  // MARK: - Outlets
  @IBOutlet weak var mapView: MKMapView!
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    
    setupMapView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    guard let mapItems = mapItems else { return }
    
    if mapItems.count == 1, let item = mapItems.first {
      title = item.name
    } else {
      title = NSLocalizedString("TITLE_ALL_PLACES", comment: "All Places view controller title")
    }
    
    // Turn the array of MKMapItem objects into an annotation with a title and URL that can be shown on the map.
    let annotations = mapItems.compactMap { (mapItem) -> PlaceAnnotation? in
      guard let coordinate = mapItem.placemark.location?.coordinate else { return nil }
      
      let annotation = PlaceAnnotation(coordinate: coordinate)
      annotation.title = mapItem.name
      annotation.url = mapItem.url
      
      return annotation
    }
    mapView.addAnnotations(annotations)
  }
  
  // MARK: - Methods
  
  /// Setup mapView in viewDidLoad()
  func setupMapView() {
    if let region = boundingRegion {
      mapView.region = region
    }
    
    // Show the compass butotn in the navigation bar
    let compass = MKCompassButton(mapView: mapView)
    compass.compassVisibility = .visible
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
    mapView.showsCompass = false // Uses compass in nav bar instead
    
    // Make sure `MKPinAnnotationView` and the reuse identifier is recognized in this map view
    mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationReuseID.pin.rawValue)
    mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
  }

} // Class end

// MARK: - MapViewDelegate ext.
extension MapViewController: MKMapViewDelegate {
  
  // Handle error case
  func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
    print("Failed to load the map: \(error)")
  }
  
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? PlaceAnnotation else { return nil }
    
    // Annotation views should be dequeued from a reuse queue to be efficent.
    let view = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationReuseID.pin.rawValue, for: annotation) as? MKMarkerAnnotationView
    view?.canShowCallout = true
    view?.clusteringIdentifier = "searchResult"
    
    // If the annotation has a URL, add an extra Info button to the annotation so users can open the URL.
    if annotation.url != nil {
      let infoButton = UIButton(type: .detailDisclosure)
      view?.rightCalloutAccessoryView = infoButton
    }
    
    return view
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let annotation = view.annotation as? PlaceAnnotation else { return }
    if let url = annotation.url {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
}
