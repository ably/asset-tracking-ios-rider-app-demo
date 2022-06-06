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
    
    weak var viewController: PublisherStatusViewController?
    let locationManager = CLLocationManager()

    let publisherResolution: Resolution
    let routingProfile: RoutingProfile
    let aatService = AATService.sharedInstance

    init(publisherResolution: Resolution, routingProfile: RoutingProfile, viewController: PublisherStatusViewController) {
        self.publisherResolution = publisherResolution
        self.routingProfile = routingProfile
        self.viewController = viewController
    }

    func viewDidLoad() {
        locationManager.requestAlwaysAuthorization()
        aatService.delegate = self
        aatService.startPublisher(publisherResolution: publisherResolution, routingProfile: routingProfile)
    }
    
    func viewWillDisappear() {
        aatService.stopPublisher()
    }
    
    func addTrackable(trackable: Trackable) {
        aatService.addTrackable(trackable: trackable, completion: {_ in})
    }
    
    func selectTrackable(trackable: Trackable) {
        aatService.trackTrackable(trackable: trackable) { result in
            print("Track Trackable result: \(result)")
        }
    }
    
    func getActiveTrackable() -> Trackable? {
        return aatService.getActiveTrackable()
    }
    
    func getActiveTrackableCoordinates() -> LocationCoordinate? {
        guard let activeTrackable = aatService.getActiveTrackable()
        else { return nil }
        
        return activeTrackable.destination
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
        let locationCoordinates = location.location.coordinate
        let horizontalAccuracy = location.location.horizontalAccuracy
        viewController?.updateCurrentLocation(latitude: String(locationCoordinates.latitude), longitude: String(locationCoordinates.longitude), horizontalAccuracy: String(horizontalAccuracy))
        print("didUpdateEnhancedLocation: \(location.location.coordinate)")
    }

    func publisher(publisher: Publisher, didChangeConnectionState state: ConnectionState, forTrackable trackable: Trackable) {
        let activeTrackable = aatService.getActiveTrackable()
        if activeTrackable?.id == trackable.id {
            viewController?.updateConnectionStatus(connectionState: state)
        }
        print("didChangeConnectionState: \(state), \nforTrackable: \(trackable.id)")
    }

    func publisher(publisher: Publisher, didUpdateResolution resolution: Resolution) {
        viewController?.updateResolutionLabels(resolution: resolution)
        print("didUpdateResolution: \(resolution)")
    }
}
