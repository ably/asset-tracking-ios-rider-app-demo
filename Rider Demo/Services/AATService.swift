//
//  AATService.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import AblyAssetTrackingPublisher
import CoreLocation.CLLocation
import UIKit

protocol AATServiceDelegate: AnyObject {
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
            return Resolution(accuracy: Accuracy.minimum, desiredInterval: 10000, minimumDisplacement: 1000)
        case .medium:
            return Resolution(accuracy: Accuracy.minimum, desiredInterval: 5000, minimumDisplacement: 500)
        case .high:
            return Resolution(accuracy: Accuracy.minimum, desiredInterval: 1000, minimumDisplacement: 100)
        }
    }
}

class AATService {
    static let sharedInstance = AATService()
    
    let ablyAPIKey = EnvironmentHelper.ablyKey
    let mapBoxKey = EnvironmentHelper.mapboxAccessToken

    var delegate: AATServiceDelegate?

    private var publisher: Publisher?

    private(set) var trackables: [Trackable] = []

    func startPublisher(publisherResolution: PublisherResolution, routingProfile: RoutingProfile) {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown device"
        // TODO: We'll be using token auth instead

         publisher = try? PublisherFactory.publishers()
            .connection(ConnectionConfiguration(apiKey: ablyAPIKey, clientId: deviceID))
            .mapboxConfiguration(MapboxConfiguration(mapboxKey: EnvironmentHelper.mapboxAccessToken))
            .log(LogConfiguration())
            .resolutionPolicyFactory(DefaultResolutionPolicyFactory(defaultResolution: publisherResolution.resolution))
            .routingProfile(routingProfile)
            .delegate(self)
            .start()
    }

    func stopPublisher(_ completion: ((Result<Void, ErrorInformation>) -> Void)? = nil) {
        publisher?.stop {[weak self] result in
            guard let self = self else { return }
            self.publisher = nil
            self.trackables = []
            completion?(result)
        }
    }

    func addTrackable(trackable: Trackable, completion: @escaping ResultHandler<Void>) {
        trackables.append(trackable)
        publisher?.add(trackable: trackable, completion: completion)
    }

    func trackTrackable(trackable: Trackable, completion: @escaping ResultHandler<Void>) {
        publisher?.track(trackable: trackable, completion: completion)
    }

    func getActiveTrackable() -> Trackable? {
        return publisher?.activeTrackable
    }
}

extension AATService: PublisherDelegate {
    // MARK: PublisherDelegate
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
