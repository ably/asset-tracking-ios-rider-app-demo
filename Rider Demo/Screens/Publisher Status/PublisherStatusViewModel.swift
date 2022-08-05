//
//  PublisherStatusViewModel.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import CoreLocation
import AblyAssetTrackingPublisher

class PublisherStatusViewModel: NSObject {
    
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
        locationManager.delegate = self
        handlePermissionsRequests()
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
            case .success:
                self.viewController?.finishedTrackingResetUI()
                print("PublisherStatusViewModel succesfully removed a trackable: \(activeTrackable.id)")
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
    
    private func handlePermissionsRequests() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            print("Location permission has been granted already")
            locationManager.allowsBackgroundLocationUpdates = true
        case .notDetermined:
            print("Location permission not determined")
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            print("Location permission restricted/denied")
            let deniedMessage = "In order to share your location with your customers you need to allow this app access to your location in the Settings."
            viewController?.showLocationPermissionSettingsDialog(message: deniedMessage)
        case .authorizedWhenInUse:
            print("location permission when in use")
            let whenInUseMessage = "In order to share your location with your customers even if the app is in the background, you need to allow this app to always access your location in the Settings"
            viewController?.showLocationPermissionSettingsDialog(message: whenInUseMessage)
        @unknown default:
            locationManager.requestAlwaysAuthorization()
        }
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

extension PublisherStatusViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handlePermissionsRequests()
    }
}
