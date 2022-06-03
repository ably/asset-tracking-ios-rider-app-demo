//
//  SetupViewController.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit
import AblyAssetTrackingPublisher
import CoreLocation

class SetupViewController: UIViewController {
    @IBOutlet private var selectResolutionSegmentedControl: UISegmentedControl!
    @IBOutlet private var routingProfileSegmentedControl: UISegmentedControl!
    @IBOutlet private var startPublisherButton: UIButton!
    
    let viewModel = SetupViewModel()

    override func viewDidLoad() {
        startPublisherButton.layer.cornerRadius = 16

        let segmentedControlBackgroundColor = UIColor(red: 50/255, green: 116/255, blue: 219/255, alpha: 1)

        selectResolutionSegmentedControl.backgroundColor = segmentedControlBackgroundColor
        selectResolutionSegmentedControl.selectedSegmentIndex = 0

        routingProfileSegmentedControl.backgroundColor = segmentedControlBackgroundColor
        routingProfileSegmentedControl.selectedSegmentIndex = 0

        super.viewDidLoad()
    }

    @IBAction private func startPublisherButtonPressed() {
        let storyboard = UIStoryboard(name: "PublisherStatus", bundle: nil)
        guard let publisherStatusViewController = storyboard.instantiateViewController(withIdentifier: "PublisherStatus") as? PublisherStatusViewController
        else { return }

        let resolution = viewModel.getSelectedPublisherResolution(resolutionIndex: selectResolutionSegmentedControl.selectedSegmentIndex)
        let routingProfile = viewModel.getSelectedRoutingProfile(routingIndex: routingProfileSegmentedControl.selectedSegmentIndex)
        
        publisherStatusViewController.configure(resolution: resolution, routingProfile: routingProfile)

        navigationController?.pushViewController(publisherStatusViewController, animated: true)
    }
}
