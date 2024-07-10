//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    func configureHierarchy(){}
    func configureLayout(){}
    func configureUI(){}
    


}
