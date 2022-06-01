//
//  PublisherStatusViewController.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit
import CoreLocation.CLLocation
import AblyAssetTrackingPublisher

class PublisherStatusViewController: UIViewController {
    
    var viewModel: PublisherStatusViewModel?
    
    func configure(resolution: PublisherResolution, trackingID: String, routingProfile: RoutingProfile, destination: LocationCoordinate? = nil) {
        viewModel = PublisherStatusViewModel(publisherResolution: resolution, trackingID: trackingID, routingProfile: routingProfile, destination: destination)
        title = "Status"
    }
    
    override func viewDidLoad() {
        viewModel?.viewDidLoad()
        
        super.viewDidLoad()
    }
    
}
