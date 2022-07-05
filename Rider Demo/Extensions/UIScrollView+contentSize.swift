//
//  AddTrackableViewController.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit

extension UIScrollView {
    func updateContentSize() {
        let margin = 20.0
        var maxY = 0.0
        for subview in subviews {
            let subviewMaxY = subview.subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
            if subviewMaxY > maxY {
                maxY = subviewMaxY
            }
        }
        
        contentSize.height = maxY + margin
    }
}
