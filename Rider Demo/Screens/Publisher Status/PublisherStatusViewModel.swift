//
//  PublisherStatusViewModel.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import CoreLocation

class PublisherStatusViewModel {
    var locationManager = CLLocationManager()

    func viewDidLoad() {
        locationManager.requestAlwaysAuthorization()
    }
}
