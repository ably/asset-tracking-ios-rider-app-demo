//
//  SelectTrackableViewController.swift
//  Rider Demo
//
//  Created by Jakub Jankowski on 02/06/2022.
//

import UIKit
import AblyAssetTrackingCore

protocol SelectTrackableDelegate: AnyObject {
    func trackableSelected(trackable: Trackable)
}

class SelectTrackableViewController: UIViewController {
    @IBOutlet var trackablesTableView: UITableView!
    
    weak var delegate: SelectTrackableDelegate?
    private let viewModel = SelectTrackableViewModel()
    
    func configure(trackables: [Trackable]) {
        viewModel.trackables = trackables
    }

    override func viewDidLoad() {
        registerTableViewCells()
        trackablesTableView.delegate = self
        trackablesTableView.dataSource = self
        super.viewDidLoad()
    }
    
    private func registerTableViewCells() {
        let cell = UINib(nibName: "TrackableTableViewCell",
                                  bundle: nil)
        self.trackablesTableView.register(cell,
                                forCellReuseIdentifier: "TrackableTableViewCell")
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
