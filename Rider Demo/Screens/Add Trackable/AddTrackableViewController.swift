//
//  AddTrackableViewController.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit
import AblyAssetTrackingCore

protocol AddTrackableDelegate: AnyObject {
    func trackableAdded(trackable: Trackable)
    func trackableAddedAndActivelyTracked(trackable: Trackable)
}

class AddTrackableViewController: UIViewController {
    @IBOutlet private var trackableIDTextField: UITextField!
    @IBOutlet private var latitudeTextField: UITextField!
    @IBOutlet private var longitudeTextField: UITextField!
    @IBOutlet private var addButton: UIButton!
    
    @IBOutlet private var addAndActivelyTrackButton: UIButton!
    var viewModel = AddTrackableViewModel()
    weak var delegate: AddTrackableDelegate?

    override func viewDidLoad() {
        title = "Add Trackable"
        addButton.layer.cornerRadius = 16
        addAndActivelyTrackButton.layer.cornerRadius = 16

        trackableIDTextField.delegate = self
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self

        latitudeTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        longitudeTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        super.viewDidLoad()
    }
    
    private func getResolutionConstraints() -> DefaultResolutionConstraints {
        DefaultResolutionConstraints(resolutions: getResolutionSet(), proximityThreshold: DefaultProximity(spatial: 1.0), batteryLevelThreshold: 15.0, lowBatteryMultiplier: 5.0)
    }
    
    private func getResolutionSet() -> DefaultResolutionSet {
        let farWithoutSubscriberResolution = Resolution(accuracy: Accuracy.minimum, desiredInterval: 2000, minimumDisplacement: 100.0)
        let farWithSubscriberResolution = Resolution(accuracy: Accuracy.balanced, desiredInterval: 1000, minimumDisplacement: 10.0)
        let nearWithoutSubscriberResolution = Resolution(accuracy: Accuracy.balanced, desiredInterval: 1000, minimumDisplacement: 10.0)
        let nearWithSubscriberResolution = Resolution(accuracy: Accuracy.high, desiredInterval: 500, minimumDisplacement: 1.0)

        return DefaultResolutionSet(farWithoutSubscriber: farWithoutSubscriberResolution, farWithSubscriber: farWithSubscriberResolution, nearWithoutSubscriber: nearWithoutSubscriberResolution, nearWithSubscriber: nearWithSubscriberResolution)
    }

    @IBAction private func addButtonTapped() {
        guard let trackableID = trackableIDTextField.text, !trackableID.isEmpty
        else { return }

        let destination = viewModel.getDestination(latitude: latitudeTextField.text, longitude: longitudeTextField.text)
        let trackable = Trackable(id: trackableID, destination: destination, constraints: getResolutionConstraints())
        delegate?.trackableAdded(trackable: trackable)
        navigationController?.popViewController(animated: true)
    }
    @IBAction private func addAndActivelyTrackButtonTapped() {
        guard let trackableID = trackableIDTextField.text, !trackableID.isEmpty
        else { return }

        let destination = viewModel.getDestination(latitude: latitudeTextField.text, longitude: longitudeTextField.text)
        let trackable = Trackable(id: trackableID, destination: destination)
        delegate?.trackableAddedAndActivelyTracked(trackable: trackable)
        navigationController?.popViewController(animated: true)
    }
}

extension AddTrackableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
