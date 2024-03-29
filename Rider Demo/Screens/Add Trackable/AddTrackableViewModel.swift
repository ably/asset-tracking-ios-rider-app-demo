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
    
    weak var viewController: AddTrackableViewController!

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
    
     func getResolutionConstraints() -> DefaultResolutionConstraints {
        DefaultResolutionConstraints(resolutions: getResolutionSet(), proximityThreshold: DefaultProximity(spatial: 1000.0), batteryLevelThreshold: 50.0, lowBatteryMultiplier: 5.0)
    }
    
    func handleTextFieldChanged() {
        if (Int(viewController.getLatitudeText()) != nil || viewController.getLatitudeText().isEmpty)
            && (Int(viewController.getLongitudeText()) != nil || viewController.getLongitudeText().isEmpty)
            && !viewController.getTrackableID().isEmpty {
            viewController.enableButtons()
        } else {
            viewController.disableButtons()
        }
    }
    
    private func getResolutionSet() -> DefaultResolutionSet {
        let farWithoutSubscriberResolution = Resolution(accuracy: Accuracy.minimum, desiredInterval: 2000, minimumDisplacement: 100.0)
        let farWithSubscriberResolution = Resolution(accuracy: Accuracy.balanced, desiredInterval: 1000, minimumDisplacement: 10.0)
        let nearWithoutSubscriberResolution = Resolution(accuracy: Accuracy.balanced, desiredInterval: 1000, minimumDisplacement: 10.0)
        let nearWithSubscriberResolution = Resolution(accuracy: Accuracy.high, desiredInterval: 500, minimumDisplacement: 1.0)

        return DefaultResolutionSet(farWithoutSubscriber: farWithoutSubscriberResolution, farWithSubscriber: farWithSubscriberResolution, nearWithoutSubscriber: nearWithoutSubscriberResolution, nearWithSubscriber: nearWithSubscriberResolution)
    }
}
