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
    @IBOutlet private var trackableIDTextField: UITextField!
    @IBOutlet private var startTrackingButton: UIButton!
    @IBOutlet private var selectResolutionSegmentedControl: UISegmentedControl!
    @IBOutlet private var latitudeTextField: UITextField!
    @IBOutlet private var longitudeTextField: UITextField!
    @IBOutlet private var routingProfileSegmentedControl: UISegmentedControl!

    let viewModel = SetupViewModel()

    override func viewDidLoad() {
        let segmentedControlBackgroundColor = UIColor(red: 50/255, green: 116/255, blue: 219/255, alpha: 1)

        startTrackingButton.layer.cornerRadius = 16
        selectResolutionSegmentedControl.backgroundColor = segmentedControlBackgroundColor
        selectResolutionSegmentedControl.selectedSegmentIndex = 0

        routingProfileSegmentedControl.backgroundColor = segmentedControlBackgroundColor
        routingProfileSegmentedControl.selectedSegmentIndex = 0

        super.viewDidLoad()
    }

    @IBAction private func startTrackingButtonPressed() {
        guard let text = trackableIDTextField.text, !text.isEmpty
        else { return }

        let storyboard = UIStoryboard(name: "PublisherStatus", bundle: nil)
        guard let publisherStatusViewController = storyboard.instantiateViewController(withIdentifier: "PublisherStatusViewController") as? PublisherStatusViewController
        else { return }

        let resolution = viewModel.getSelectedPublisherResolution(resolutionIndex: selectResolutionSegmentedControl.selectedSegmentIndex)
        let routingProfile = viewModel.getSelectedRoutingProfile(routingIndex: routingProfileSegmentedControl.selectedSegmentIndex)
        let destination = viewModel.getDestination(latitude: latitudeTextField.text, longitude: longitudeTextField.text)

        publisherStatusViewController.configure(resolution: resolution, trackingID: text, routingProfile: routingProfile, destination: destination ?? nil)

        navigationController?.pushViewController(publisherStatusViewController, animated: true)
    }
}
