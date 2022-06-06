//
//  SetupViewModel.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import CoreLocation
import AblyAssetTrackingPublisher

class SetupViewModel: NSObject {

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

    func getSelectedRoutingProfile(routingIndex: Int) -> RoutingProfile {
        switch routingIndex {
        case 0:
            return RoutingProfile.driving
        case 1:
            return RoutingProfile.cycling
        case 2:
            return RoutingProfile.walking
        case 3:
            return RoutingProfile.drivingTraffic
        default:
            return RoutingProfile.driving
        }
    }

    func getSelectedPublisherResolutionAccuracy(accuracyIndex: Int) -> Accuracy {
        switch accuracyIndex {
        case 0:
            return Accuracy.minimum
        case 1:
            return Accuracy.low
        case 2:
            return Accuracy.balanced
        case 3:
            return Accuracy.high
        case 4:
            return Accuracy.maximum
        default:
            return Accuracy.low
        }
    }
}
