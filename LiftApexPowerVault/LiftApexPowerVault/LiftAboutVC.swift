//
//  AboutVC.swift
//  LiftApexPowerVault
//
//  Created by jin fu on 2024/11/13.
//

import UIKit

class LiftAboutVC: UIViewController {

    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Functions
    
    
    //MARK: - Declare IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
