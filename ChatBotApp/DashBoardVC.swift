//
//  DashBoardVCViewController.swift
//  ChatBotApp
//
//  Created by Oneview Infosys on 05/02/19.
//  Copyright © 2019 Oneview Infosys. All rights reserved.
//

import UIKit


class DashBoardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func botButtonTapped(_ sender: Any) {
        ChatbotManager.sharedInstance.navigateToVideoCallViewController()
    }



}
