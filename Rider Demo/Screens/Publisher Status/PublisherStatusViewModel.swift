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
    
    var minAcceptanceDistance = 150

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
        aatService.addTrackable(trackable: trackable) {[weak self] result in
            switch result {
            case .success:
                print("PublisherStatusViewModel - succesfully added a trackable")
            case .failure(let errorInfo):
                self?.viewController?.showErrorDialog(message: errorInfo.message)
                print("PublisherStatusViewModel addTrackable error: \(errorInfo), trackable: \(trackable.id)")

            }
        }
    }
    
    func selectTrackable(trackable: Trackable, completion: @escaping ResultHandler<Void>) {
        aatService.trackTrackable(trackable: trackable) {[weak self] result in
            switch result {
            case .success:
                print("PublisherStatusViewModel - succesfully tracked a trackable")
            case .failure(let errorInfo):
                self?.viewController?.showErrorDialog(message: errorInfo.message)
                print("PublisherStatusViewModel selectTrackable error: \(errorInfo), trackable: \(trackable.id)")
            }
            completion(result)
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
    
    func handleFinishTracking() {
        guard let activeTrackable = getActiveTrackable() else { return }
        aatService.removeTrackable(trackable: activeTrackable) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if success == true {
                    self.viewController?.finishedTrackingResetUI()
                    print("PublisherStatusViewModel succesfully removed a trackable: \(activeTrackable.id)")
                }
            case .failure(let errorInfo):
                print("PublisherStatusViewModel removeTrackable error: \(errorInfo), trackable: \(activeTrackable.id)")
                self.viewController?.showErrorDialog(message: errorInfo.message)
            }
        }
    }
    
    private func determineDistanceToDestination(currentLocation: CLLocation) {
        guard let destination2d = getActiveTrackableCoordinates()
        else { return }
        
        let destination = CLLocation(latitude: destination2d.latitude, longitude: destination2d.longitude)
        let distance = currentLocation.distance(from: destination)
        viewController?.updateDistance(distance: Int(distance))
    }
}

extension PublisherStatusViewModel: AATServiceDelegate {
    func publisher(publisher: Publisher, didFailWithError error: ErrorInformation) {
        viewController?.showErrorDialog(message: error.message)
        print("PublisherStatusViewModel didFailWithError: \(error)")
    }
    
    func publisher(publisher: Publisher, didUpdateEnhancedLocation location: EnhancedLocationUpdate) {
        let locationCoordinates = location.location.coordinate
        let horizontalAccuracy = location.location.horizontalAccuracy
        
        let coreLocation = location.location.toCoreLocation()
        determineDistanceToDestination(currentLocation: coreLocation)
        
        viewController?.updateCurrentLocation(latitude: String(locationCoordinates.latitude), longitude: String(locationCoordinates.longitude), horizontalAccuracy: String(Int(horizontalAccuracy)))
        print("PublisherStatusViewModel didUpdateEnhancedLocation: \(location.location.coordinate)")
    }

    func publisher(publisher: Publisher, didChangeConnectionState state: ConnectionState, forTrackable trackable: Trackable) {
        let activeTrackable = aatService.getActiveTrackable()
        if activeTrackable?.id == trackable.id {
            viewController?.updateConnectionStatus(connectionState: state)
        }
        print("PublisherStatusViewModel didChangeConnectionState: \(state), forTrackable: \(trackable.id)")
    }

    func publisher(publisher: Publisher, didUpdateResolution resolution: Resolution) {
        viewController?.updateResolutionLabels(resolution: resolution)
        print("PublisherStatusViewModel didUpdateResolution: \(resolution)")
    }
}
