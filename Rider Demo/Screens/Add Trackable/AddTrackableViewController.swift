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
        viewModel.viewController = self
        
        title = "Add Trackable"
        addButton.layer.cornerRadius = 16
        addAndActivelyTrackButton.layer.cornerRadius = 16
        disableButtons()

        trackableIDTextField.delegate = self
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self

        latitudeTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        longitudeTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        trackableIDTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        latitudeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        longitudeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        super.viewDidLoad()
    }
    
    func getTrackableID() -> String {
        return trackableIDTextField.text ?? ""
    }
    
    func getLatitudeText() -> String {
        return latitudeTextField.text ?? ""
    }
    
    func getLongitudeText() -> String {
        return longitudeTextField.text ?? ""
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.handleTextFieldChanged()
    }
    
    func disableButtons() {
        addButton.backgroundColor = UIColor.gray
        addButton.isEnabled = false
        addAndActivelyTrackButton.backgroundColor = UIColor.gray
        addAndActivelyTrackButton.isEnabled = false
    }
    
    func enableButtons() {
        addButton.isEnabled = true
        addButton.backgroundColor = UIColor.systemRed
        addAndActivelyTrackButton.isEnabled = true
        addAndActivelyTrackButton.backgroundColor = UIColor.systemRed
    }

    @IBAction private func addButtonTapped() {
        guard let trackableID = trackableIDTextField.text, !trackableID.isEmpty
        else { return }

        let destination = viewModel.getDestination(latitude: latitudeTextField.text, longitude: longitudeTextField.text)
        let trackable = Trackable(id: trackableID, destination: destination, constraints: viewModel.getResolutionConstraints())
        delegate?.trackableAdded(trackable: trackable)
        navigationController?.popViewController(animated: true)
    }
    @IBAction private func addAndActivelyTrackButtonTapped() {
        guard let trackableID = trackableIDTextField.text, !trackableID.isEmpty
        else { return }

        let destination = viewModel.getDestination(latitude: latitudeTextField.text, longitude: longitudeTextField.text)
        let trackable = Trackable(id: trackableID, destination: destination, constraints: viewModel.getResolutionConstraints())
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
