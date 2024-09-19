//
//  ViewController.swift
//  TurkcellApi3
//
//  Created by Sefa Aycicek on 19.09.2024.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let viewModel = ViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeItems()
        
        viewModel.getData()
    }
    
    func observeItems() {
        viewModel.data
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                
            }.disposed(by: viewModel.disposeBag)
    }
}

