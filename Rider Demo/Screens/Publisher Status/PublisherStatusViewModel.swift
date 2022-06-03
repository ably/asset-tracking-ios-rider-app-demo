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
    let routingProfile: RoutingProfile

    let aatService = AATService.sharedInstance

    init(publisherResolution: PublisherResolution, routingProfile: RoutingProfile) {
        self.publisherResolution = publisherResolution
        self.routingProfile = routingProfile
    }

    func viewDidLoad() {
        locationManager.requestAlwaysAuthorization()
        aatService.startPublisher(publisherResolution: publisherResolution, routingProfile: routingProfile)
    }
    
    func viewWillDisappear() {
        aatService.stopPublisher()
    }
    
    func addTrackable(trackable: Trackable) {
        aatService.addTrackable(trackable: trackable, completion: {_ in})
    }
    
    func selectTrackable(trackable: Trackable) {
        
    }
    
    func getTrackables() -> [Trackable] {
        return aatService.trackables
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
