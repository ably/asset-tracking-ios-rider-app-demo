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

    func getSelectedPublisherResolution(resolutionIndex: Int) -> PublisherResolution {
        switch resolutionIndex {
        case 0:
            return PublisherResolution.low
        case 1:
            return PublisherResolution.medium
        case 2:
            return PublisherResolution.high
        default:
            return PublisherResolution.low
        }
    }
}
