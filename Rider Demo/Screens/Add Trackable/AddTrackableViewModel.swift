//
//  AddTrackableViewModel.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import CoreLocation
import AblyAssetTrackingPublisher

class AddTrackableViewModel {

    func getDestination(latitude: String?, longitude: String?) -> LocationCoordinate? {
        guard let latitude = latitude,
              let longitude = longitude,
              let latitudeDegrees = CLLocationDegrees(latitude),
              let longitudeDegrees = CLLocationDegrees(longitude)
        else {
            return nil
        }

        return LocationCoordinate(latitude: latitudeDegrees, longitude: longitudeDegrees)
    }
}
