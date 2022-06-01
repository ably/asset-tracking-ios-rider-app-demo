//
//  AATService.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import AblyAssetTrackingPublisher
import CoreLocation.CLLocation

protocol AATServiceDelegate {
    func publisher(publisher: Publisher, didFailWithError error: ErrorInformation)
    
    func publisher(publisher: Publisher, didUpdateEnhancedLocation location: EnhancedLocationUpdate)
    
    func publisher(publisher: Publisher, didChangeConnectionState state: ConnectionState, forTrackable trackable: Trackable)
    
    func publisher(publisher: Publisher, didUpdateResolution resolution: Resolution)
}

enum PublisherResolution {
    
    case low
    case medium
    case high
    
    var resolution: Resolution {
        switch self {
        case .low:
            return Resolution(accuracy: Accuracy.minimum, desiredInterval: 10000, minimumDisplacement: 100)
        case .medium:
            return Resolution(accuracy: Accuracy.minimum, desiredInterval: 5000, minimumDisplacement: 30)
        case .high:
            return Resolution(accuracy: Accuracy.minimum, desiredInterval: 1000, minimumDisplacement: 5)
        }
    }
}

class AATService {
    let ablyAPIKey = EnvironmentHelper.ABLY_API_KEY
    let mapBoxKey = EnvironmentHelper.MAPBOX_ACCESS_TOKEN
    
    var delegate: AATServiceDelegate?
    
    private var publisher: Publisher?
    
    func startPublisher(trackableID: String, publisherResolution: PublisherResolution, routingProfile: RoutingProfile, destination: LocationCoordinate? = nil) {
        //TODO: We'll be using token auth instead

         publisher = try? PublisherFactory.publishers()
            .connection(ConnectionConfiguration(apiKey: ablyAPIKey, clientId: "ios demo rider id"))
            .mapboxConfiguration(MapboxConfiguration(mapboxKey: EnvironmentHelper.MAPBOX_ACCESS_TOKEN))
            .log(LogConfiguration())
            .resolutionPolicyFactory(DefaultResolutionPolicyFactory(defaultResolution: publisherResolution.resolution))
            .routingProfile(routingProfile)
            .delegate(self)
            .start()
        
        publisher?.track(trackable: Trackable(id: trackableID, destination: destination), completion:  { _ in})

    }
    
    func addTrackable(trackable: Trackable, completion: ((Result<Void, ErrorInformation>) -> Void)? = nil) {
        publisher?.add(trackable: trackable, completion: completion ?? { _ in})
    }
    
    func trackTrackable(trackable: Trackable, completion: ((Result<Void, ErrorInformation>) -> Void)? = nil) {
        publisher?.track(trackable: trackable, completion: completion ?? { _ in})
    }
    
    func stopPublisher(_ completion: ((Result<Void, ErrorInformation>) -> Void)? = nil) {
        publisher?.stop {[weak self] result in
            self?.publisher = nil
            completion?(result)
        }
    }
}

extension AATService: PublisherDelegate {
    //MARK: PublisherDelegate
    func publisher(sender: Publisher, didFailWithError error: ErrorInformation) {
        delegate?.publisher(publisher: sender, didFailWithError: error)
    }
    
    func publisher(sender: Publisher, didUpdateEnhancedLocation location: EnhancedLocationUpdate) {
        delegate?.publisher(publisher: sender, didUpdateEnhancedLocation: location)
    }
    
    func publisher(sender: Publisher, didChangeConnectionState state: ConnectionState, forTrackable trackable: Trackable) {
        delegate?.publisher(publisher: sender, didChangeConnectionState: state, forTrackable: trackable)
    }
    
    func publisher(sender: Publisher, didUpdateResolution resolution: Resolution) {
        delegate?.publisher(publisher: sender, didUpdateResolution: resolution)
    }
}
