//
//  HomeVC.swift
//  LiftApexPowerVault
//
//  Created by LiftApexPowerVault on 2024/11/13.
//

import UIKit

class LiftHomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
