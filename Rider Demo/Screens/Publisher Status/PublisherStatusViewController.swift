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
    @IBOutlet private var connectionStatusLabel: UILabel!
    @IBOutlet private var desiredResolutionLabel: UILabel!
    @IBOutlet private var desiredAccuracyLabel: UILabel!
    @IBOutlet private var desiredMinimumDisplacementLabel: UILabel!
    @IBOutlet private var desiredIntervalLabel: UILabel!
    
    @IBOutlet private var currentResolutionLabel: UILabel!
    @IBOutlet private var currentMinimumDisplacementLabel: UILabel!
    @IBOutlet private var currentAccuracyLabel: UILabel!
    @IBOutlet private var currentDesiredIntervalLabel: UILabel!
    
    @IBOutlet private var destinationLongitudeLabel: UILabel!
    @IBOutlet private var destinationLatitudeLabel: UILabel!
    @IBOutlet private var currentLatitudeLabel: UILabel!
    @IBOutlet private var currentLongitudeLabel: UILabel!
    @IBOutlet private var horizontalAccuracyLabel: UILabel!
    
    @IBOutlet private var activelyTrackedTrackable: UILabel!
    var viewModel: PublisherStatusViewModel?

    func configure(resolution: Resolution, routingProfile: RoutingProfile) {
        viewModel = PublisherStatusViewModel(publisherResolution: resolution, routingProfile: routingProfile, viewController: self)
        title = "Status"
    }

    override func viewDidLoad() {
        guard let viewModel = viewModel else {
            super.viewDidLoad()
            return
        }

        viewModel.viewDidLoad()
        
        desiredAccuracyLabel.text = "Desired accuracy: \(viewModel.publisherResolution.accuracy.rawValue)"
        desiredMinimumDisplacementLabel.text = "Desired Minimum Displacement: \(viewModel.publisherResolution.minimumDisplacement) m"
        desiredIntervalLabel.text = "Desired Interval: \(viewModel.publisherResolution.desiredInterval) ms"
        
        currentAccuracyLabel.text = "Desired accuracy: \(viewModel.publisherResolution.accuracy.rawValue)"
        currentMinimumDisplacementLabel.text = "Desired Minimum Displacement: \(viewModel.publisherResolution.minimumDisplacement) m"
        currentDesiredIntervalLabel.text = "Desired Interval: \(viewModel.publisherResolution.desiredInterval) ms"
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activelyTrackedTrackable.text = "Actively tracked trackable: \(viewModel?.getActiveTrackable()?.id ?? "none")"
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            viewModel?.viewWillDisappear()
        }
        
        super.viewWillDisappear(animated)
    }
    
    func updateResolutionLabels(resolution: Resolution) {
        currentAccuracyLabel.text = "Desired accuracy: \(resolution.accuracy.rawValue)"
        currentMinimumDisplacementLabel.text = "Desired Minimum Displacement: \(resolution.minimumDisplacement) m"
        currentDesiredIntervalLabel.text = "Desired Interval: \(resolution.desiredInterval) ms"
    }
    
    func updateConnectionStatus(connectionState: ConnectionState) {
        connectionStatusLabel.text = "Actively Tracked Connection Status: \(connectionState)"
    }
    
    func updateCurrentLocation(latitude: String, longitude: String, horizontalAccuracy: String) {
        currentLatitudeLabel.text = "Latitude: \(latitude)"
        currentLongitudeLabel.text = "Longitude: \(longitude)"
        horizontalAccuracyLabel.text = "Horizontal Accuracy: \(horizontalAccuracy) m"
    }
    
    @IBAction private func selectTrackableButtonTapped() {
        let storyboard = UIStoryboard(name: "SelectTrackable", bundle: nil)
        guard let selectTrackableViewController = storyboard.instantiateViewController(withIdentifier: "SelectTrackable") as? SelectTrackableViewController
        else { return }
        
        selectTrackableViewController.delegate = self
        selectTrackableViewController.configure(trackables: viewModel?.getTrackables() ?? [])
        navigationController?.pushViewController(selectTrackableViewController, animated: true)
    }

    @IBAction private func addTrackableButtonTapped() {
        let storyboard = UIStoryboard(name: "AddTrackable", bundle: nil)
        guard let addTrackableViewController = storyboard.instantiateViewController(withIdentifier: "AddTrackable") as? AddTrackableViewController
        else { return }
        
        addTrackableViewController.delegate = self
        
        navigationController?.pushViewController(addTrackableViewController, animated: true)
    }
}

extension PublisherStatusViewController: AddTrackableDelegate {
    func trackableAdded(trackable: Trackable) {
        viewModel?.addTrackable(trackable: trackable)
    }
}

extension PublisherStatusViewController: SelectTrackableDelegate {
    func trackableSelected(trackable: Trackable) {
        viewModel?.selectTrackable(trackable: trackable)
        
        if let activeTrackableCoordinates = viewModel?.getActiveTrackableCoordinates() {
            destinationLatitudeLabel.text = "Latitude: \(activeTrackableCoordinates.latitude)"
            destinationLongitudeLabel.text = "Latitude: \(activeTrackableCoordinates.longitude)"
        }
        
        print("Trackable selected: trackable")
    }
}
