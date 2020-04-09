//
//  MKPlacemark+Extension.swift
//  AutoPopulateMap
//
//  Created by Jon Corn on 4/7/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import MapKit
import Contacts

extension MKPlacemark {
  var formattedAddress: String? {
    guard let postalAddress = postalAddress else { return nil }
    return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
  }
}
