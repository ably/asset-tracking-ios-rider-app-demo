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
        selectResolutionSegmentedControl.backgroundColor = UIColor(red: 0, green: 128, blue: 255, alpha: 0)
        selectResolutionSegmentedControl.selectedSegmentIndex = 0
    
        viewModel.viewController = self
        super.viewDidLoad()
    }
    
    @IBAction private func startTrackingButtonPressed() {
        let storyboard = UIStoryboard(name: "PublisherStatus", bundle: nil)
        let publisherStatusViewController = storyboard.instantiateViewController(withIdentifier: "PublisherStatusViewController") as! PublisherStatusViewController
        
        publisherStatusViewController.configure()
        
        navigationController?.pushViewController(publisherStatusViewController, animated: true)
    }
}
