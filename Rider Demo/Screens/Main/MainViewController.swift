//
//  ViewController.swift
//  Rider Demo
//
//  Copyright 2022 Ably Real-time Ltd (ably.com)
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        
        viewModel.viewDidLoad()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

