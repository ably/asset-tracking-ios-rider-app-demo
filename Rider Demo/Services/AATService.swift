//
//  AATService.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import Foundation
import AblyAssetTrackingPublisher

class AATService: NSObject, PublisherDelegate {
    let ableAPIKey = EnvironmentHelper.ABLY_API_KEY
    let mapBoxKey = EnvironmentHelper.MAPBOX_ACCESS_TOKEN
    
    private var publisher: Publisher?
        
    override init() {
        
        super.init()
    }
    
    func setupPublisher(clientID: String) {
        //TODO: We'll be using token auth instead
         publisher = try? PublisherFactory.publishers()
            .connection(ConnectionConfiguration(apiKey: ableAPIKey, clientId: clientID))
            .mapboxConfiguration(MapboxConfiguration(mapboxKey: EnvironmentHelper.MAPBOX_ACCESS_TOKEN))
            .log(LogConfiguration())
            .routingProfile(RoutingProfile.cycling)
            .delegate(self)
            .start()
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
    
    //MARK: PublisherDelegate
    func publisher(sender: Publisher, didFailWithError error: ErrorInformation) {
        print("didFailWithError: \(error)")
    }
    
    func publisher(sender: Publisher, didUpdateEnhancedLocation location: EnhancedLocationUpdate) {
        print("didUpdateEnhancedLocation: \(location)")
    }
    
    func publisher(sender: Publisher, didChangeConnectionState state: ConnectionState, forTrackable trackable: Trackable) {
        print("didChangeConnectionState: \(state), \nforTrackable: \(trackable)")
    }
    
    func publisher(sender: Publisher, didUpdateResolution resolution: Resolution) {
        print("didUpdateResolution: \(resolution)")
    }
    
}
