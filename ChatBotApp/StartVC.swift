//
//  StartVC.swift
//  ChatBotApp
//
//  Created by Preeteesh Remalli on 06/02/19.
//  Copyright © 2019 Oneview Infosys. All rights reserved.
//

import UIKit
import liquid_swipe

class StartVC: LiquidSwipeContainerController, LiquidSwipeContainerDataSource{

    var viewControllers: [UIViewController] = {
        let firstPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Second")
        let secondPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Dashboard")
        var controllers: [UIViewController] = [firstPageVC, secondPageVC]
        return controllers
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfControllersInLiquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController) -> Int {
        return viewControllers.count
    }
    
    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController, viewControllerAtIndex index: Int) -> UIViewController {
        return viewControllers[index]
    }

}
