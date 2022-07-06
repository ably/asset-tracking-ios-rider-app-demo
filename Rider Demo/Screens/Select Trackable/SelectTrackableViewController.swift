//
//  SelectTrackableViewController.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit
import AblyAssetTrackingCore

protocol SelectTrackableDelegate: AnyObject {
    func trackableSelected(trackable: Trackable)
}

class SelectTrackableViewController: UIViewController {
    @IBOutlet private var startTrackingButton: UIButton!
    @IBOutlet private var trackablesTableView: UITableView!
    
    weak var delegate: SelectTrackableDelegate?
    private let viewModel = SelectTrackableViewModel()
    
    func configure(trackables: [Trackable]) {
        viewModel.trackables = trackables
    }

    override func viewDidLoad() {
        title = "Select Active Trackable"
        registerTableViewCells()
        trackablesTableView.delegate = self
        trackablesTableView.dataSource = self
        startTrackingButton.layer.cornerRadius = 16
        disableStartTrackingButton()

        super.viewDidLoad()
    }
    
    private func registerTableViewCells() {
        let cell = UINib(nibName: "TrackableTableViewCell",
                                  bundle: nil)
        self.trackablesTableView.register(cell,
                                forCellReuseIdentifier: "TrackableTableViewCell")
    }
    
    func disableStartTrackingButton() {
        startTrackingButton.backgroundColor = UIColor.gray
        startTrackingButton.isEnabled = false
    }
    
    func enableStartTrackingButton() {
        startTrackingButton.isEnabled = true
        startTrackingButton.backgroundColor = UIColor.systemRed
    }
    
    @IBAction private func startTrackingButtonTapped() {
        guard let selectedRowIndexPath = trackablesTableView.indexPathForSelectedRow
        else { return }
        
        let selectedTrackable = viewModel.trackables[selectedRowIndexPath.row]
        delegate?.trackableSelected(trackable: selectedTrackable)
        navigationController?.popViewController(animated: true)
    }
}

extension SelectTrackableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        enableStartTrackingButton()
    }
}

extension SelectTrackableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trackables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trackable = viewModel.trackables[indexPath.row]
        
        guard let cell = trackablesTableView.dequeueReusableCell(withIdentifier: "TrackableTableViewCell") as? TrackableTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(trackableID: trackable.id)
        cell.setSelected(false, animated: false)

        return cell
    }
}
