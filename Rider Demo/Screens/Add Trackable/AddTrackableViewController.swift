//
//  AddTrackableViewController.swift
//  Rider Demo
//
//  Created by Jakub Jankowski on 02/06/2022.
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

    @IBAction private func addButtonTapped() {
        guard let trackableID = trackableIDTextField.text, !trackableID.isEmpty
        else { return }

        let destination = viewModel.getDestination(latitude: latitudeTextField.text, longitude: longitudeTextField.text)
        let trackable = Trackable(id: trackableID, destination: destination)
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
