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

    func configure(resolution: PublisherResolution, routingProfile: RoutingProfile) {
        viewModel = PublisherStatusViewModel(publisherResolution: resolution, routingProfile: routingProfile)
        title = "Status"
    }

    override func viewDidLoad() {
        viewModel?.viewDidLoad()

        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            viewModel?.viewWillDisappear()
        }
        
        super.viewWillDisappear(animated)
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
        print("Trackable selected: trackable")
    }
}
