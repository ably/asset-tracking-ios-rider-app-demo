//
//  PublisherStatusViewModel.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import CoreLocation

class PublisherStatusViewModel {
    let locationManager = CLLocationManager()
    
    let publisherResolution: PublisherResolution
    let trackingID: String
    
    let aatService = AATService()
    
    init(publisherResolution: PublisherResolution, trackingID: String) {
        self.publisherResolution = publisherResolution
        self.trackingID = trackingID
    }

    func viewDidLoad() {
        locationManager.requestAlwaysAuthorization()
    }
}
