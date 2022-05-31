//
//  PublisherStatusViewController.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit

class PublisherStatusViewController: UIViewController {
    
    var viewModel: PublisherStatusViewModel?
    
    func configure() {
        
    }
    
    override func viewDidLoad() {
        viewModel = PublisherStatusViewModel()
        viewModel?.viewDidLoad()
        
        super.viewDidLoad()
    }
    
}
