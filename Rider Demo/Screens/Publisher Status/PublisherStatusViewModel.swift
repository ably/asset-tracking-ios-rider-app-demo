//
//  PublisherStatusViewModel.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import CoreLocation
import AblyAssetTrackingPublisher

class PublisherStatusViewModel {
    
    let locationManager = CLLocationManager()
    
    let publisherResolution: PublisherResolution
    let trackingID: String
    let routingProfile: RoutingProfile
    let destination: LocationCoordinate?
    
    let aatService = AATService()
    
    init(publisherResolution: PublisherResolution, trackingID: String, routingProfile: RoutingProfile, destination: LocationCoordinate? = nil) {
        self.publisherResolution = publisherResolution
        self.trackingID = trackingID
        self.routingProfile = routingProfile
        self.destination = destination
    }

    func viewDidLoad() {
        locationManager.requestAlwaysAuthorization()
        aatService.startPublisher(trackableID: trackingID, publisherResolution: publisherResolution, routingProfile: routingProfile, destination: destination)
    }
}

extension PublisherStatusViewModel: AATServiceDelegate {
    func publisher(publisher: Publisher, didFailWithError error: ErrorInformation) {
        print("didFailWithError: \(error)")
    }
    
    func publisher(publisher: Publisher, didUpdateEnhancedLocation location: EnhancedLocationUpdate) {
        print("didUpdateEnhancedLocation: \(location)")
    }
    
    func publisher(publisher: Publisher, didChangeConnectionState state: ConnectionState, forTrackable trackable: Trackable) {
        print("didChangeConnectionState: \(state), \nforTrackable: \(trackable)")
    }
    
    func publisher(publisher: Publisher, didUpdateResolution resolution: Resolution) {
        print("didUpdateResolution: \(resolution)")
    }
}
