//
//  PublisherStatusViewController.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit

class PublisherStatusViewController: UIViewController {
    
    var viewModel: PublisherStatusViewModel?
    
    func configure(resolution: PublisherResolution, trackingID: String) {
        viewModel = PublisherStatusViewModel(publisherResolution: resolution, trackingID: trackingID)
    }
    
    override func viewDidLoad() {
        viewModel?.viewDidLoad()
        
        super.viewDidLoad()
    }
    
}
