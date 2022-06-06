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
    @IBOutlet private var routingProfileSegmentedControl: UISegmentedControl!
    @IBOutlet private var startPublisherButton: UIButton!
    @IBOutlet private var minimumDisplacementTextField: UITextField!
    @IBOutlet private var desiredIntervalTextField: UITextField!
    @IBOutlet private var accuracySegmentedControl: UISegmentedControl!
    
    let viewModel = SetupViewModel()

    override func viewDidLoad() {
        startPublisherButton.layer.cornerRadius = 16
        
        let segmentedControlBackgroundColor = UIColor(red: 50/255, green: 116/255, blue: 219/255, alpha: 1)
        routingProfileSegmentedControl.backgroundColor = segmentedControlBackgroundColor
        routingProfileSegmentedControl.selectedSegmentIndex = 0
        
        accuracySegmentedControl.backgroundColor = segmentedControlBackgroundColor
        accuracySegmentedControl.selectedSegmentIndex = 0

        minimumDisplacementTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        desiredIntervalTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        minimumDisplacementTextField.delegate = self
        desiredIntervalTextField.delegate = self

        super.viewDidLoad()
    }

    @IBAction private func startPublisherButtonPressed() {
        let storyboard = UIStoryboard(name: "PublisherStatus", bundle: nil)
        guard let publisherStatusViewController = storyboard.instantiateViewController(withIdentifier: "PublisherStatus") as? PublisherStatusViewController,
              let minimumDisplacementText = minimumDisplacementTextField.text,
              !minimumDisplacementText.isEmpty,
              let minimumDisplacement = Double(minimumDisplacementText),
              let desiredIntervalText = desiredIntervalTextField.text,
              !desiredIntervalText.isEmpty,
              let desiredInterval = Double(desiredIntervalText)
        else { return }

        let accuracy = viewModel.getSelectedPublisherResolutionAccuracy(accuracyIndex: accuracySegmentedControl.selectedSegmentIndex)
        let routingProfile = viewModel.getSelectedRoutingProfile(routingIndex: routingProfileSegmentedControl.selectedSegmentIndex)
        
        let resolution = Resolution(accuracy: accuracy, desiredInterval: desiredInterval, minimumDisplacement: minimumDisplacement)
        
        publisherStatusViewController.configure(resolution: resolution, routingProfile: routingProfile)

        navigationController?.pushViewController(publisherStatusViewController, animated: true)
    }
}

extension SetupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
