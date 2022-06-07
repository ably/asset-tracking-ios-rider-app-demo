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

class AATService {
    static let sharedInstance = AATService()
    
    let ablyAPIKey = EnvironmentHelper.ablyKey
    let mapBoxKey = EnvironmentHelper.mapboxAccessToken

    var delegate: AATServiceDelegate?
    
    private(set) var desiredResolution: Resolution?
    private var publisher: Publisher?
    private(set) var trackables: [Trackable] = []

    func startPublisher(publisherResolution: Resolution, routingProfile: RoutingProfile) {
        desiredResolution = publisherResolution
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown device"
        // TODO: We'll be using token auth instead
        
         publisher = try? PublisherFactory.publishers()
            .connection(ConnectionConfiguration(apiKey: ablyAPIKey, clientId: deviceID))
            .mapboxConfiguration(MapboxConfiguration(mapboxKey: EnvironmentHelper.mapboxAccessToken))
            .log(LogConfiguration())
            .resolutionPolicyFactory(DefaultResolutionPolicyFactory(defaultResolution: publisherResolution))
            .routingProfile(routingProfile)
            .delegate(self)
            .start()
    }

    func stopPublisher(_ completion: ((Result<Void, ErrorInformation>) -> Void)? = nil) {
        publisher?.stop {[weak self] result in
            guard let self = self else { return }
            self.publisher = nil
            self.trackables = []
            self.desiredResolution = nil
            completion?(result)
        }
    }

    func addTrackable(trackable: Trackable, completion: @escaping ResultHandler<Void>) {
        publisher?.add(trackable: trackable, completion: {[weak self] result in
            switch result {
            case .success:
                self?.trackables.append(trackable)
            case .failure(let errorInfo):
                print("AATService addTrackable error: \(errorInfo), trackable: \(trackable.id)")
            }
            completion(result)
        })
    }

    func trackTrackable(trackable: Trackable, completion: @escaping ResultHandler<Void>) {
        publisher?.track(trackable: trackable, completion: {[weak self] result in
            switch result {
            case .success:
                self?.trackables.append(trackable)
            case .failure(let errorInfo):
                print("AATService trackTrackable error: \(errorInfo), trackable: \(trackable.id)")
            }
            completion(result)
        })
    }
    
    func removeTrackable(trackable: Trackable, completion: @escaping ResultHandler<Bool>) {
        publisher?.remove(trackable: trackable, completion: {[weak self] result in
            switch result {
            case .success(let success):
                if success == true {
                    self?.trackables.removeAll { $0.id == trackable.id }
                    print("")
                }
            case .failure(let errorInfo):
                print("AATService removeTrackable error: \(errorInfo), trackable: \(trackable.id)")
            }
            completion(result)
        })
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
        print("aatService didChangeConnectionState: \(state), forTrackable: \(trackable.id)")
    }

    func publisher(sender: Publisher, didUpdateResolution resolution: Resolution) {
        delegate?.publisher(publisher: sender, didUpdateResolution: resolution)
        print("aatService didUpdateResolution: \(resolution)")
    }
}
