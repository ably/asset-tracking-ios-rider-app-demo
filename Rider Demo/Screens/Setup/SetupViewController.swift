//
//  SetupViewController.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit

class SetupViewController: UIViewController {
    @IBOutlet private var trackableIDTextField: UITextField!
    @IBOutlet private var startTrackingButton: UIButton!
    @IBOutlet private var selectResolutionSegmentedControl: UISegmentedControl!
    
    let viewModel = SetupViewModel()
    
    override func viewDidLoad() {
        startTrackingButton.layer.cornerRadius = 16
        selectResolutionSegmentedControl.backgroundColor = UIColor(red: 50/255, green: 116/255, blue: 219/255, alpha: 1)
        selectResolutionSegmentedControl.selectedSegmentIndex = 0
    
        super.viewDidLoad()
    }
    
    @IBAction private func startTrackingButtonPressed() {
        guard let text = trackableIDTextField.text, !text.isEmpty
        else { return }
        
        let storyboard = UIStoryboard(name: "PublisherStatus", bundle: nil)
        let publisherStatusViewController = storyboard.instantiateViewController(withIdentifier: "PublisherStatusViewController") as! PublisherStatusViewController
        
        let resolution = getSelectedPublisherResolution()
        
        publisherStatusViewController.configure(resolution: resolution, trackingID: trackableIDTextField.text ?? "")
        
        navigationController?.pushViewController(publisherStatusViewController, animated: true)
    }
    
    private func getSelectedPublisherResolution() -> PublisherResolution {
        switch selectResolutionSegmentedControl.selectedSegmentIndex {
        case 0:
            return PublisherResolution.low
        case 1:
            return PublisherResolution.medium
        case 2:
            return PublisherResolution.high
        default:
            return PublisherResolution.low
        }
    }
}
