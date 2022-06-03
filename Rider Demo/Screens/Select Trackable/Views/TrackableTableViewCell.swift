//
//  TableViewCell.swift
//  Rider Demo
//
//  Created by Jakub Jankowski on 02/06/2022.
//

import UIKit

class TrackableTableViewCell: UITableViewCell {

    @IBOutlet private var selectedIndicatorView: UIView!
    @IBOutlet private var trackableIDLabel: UILabel!
    
    private let selectedIndicatorViewColor = UIColor(red: 50/255, green: 116/255, blue: 219/255, alpha: 1)
    
    func configure(trackableID: String) {
        trackableIDLabel.text = trackableID
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedIndicatorView.layer.cornerRadius = trackableIDLabel.bounds.height/2
        selectedIndicatorView.layer.borderColor = selectedIndicatorViewColor.cgColor
        selectedIndicatorView.layer.borderWidth = 2
        selectedIndicatorView.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            selectedIndicatorView.backgroundColor = selectedIndicatorViewColor
        } else {
            selectedIndicatorView.backgroundColor = UIColor.clear
        }
    }
}
