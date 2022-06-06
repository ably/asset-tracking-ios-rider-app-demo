//
//  AddTrackableViewModel.swift
//  Rider Demo
//
//  Created by Jakub Jankowski on 02/06/2022.
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