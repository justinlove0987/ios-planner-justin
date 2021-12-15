//
//  MainTabBarController.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/10.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    

    func configureViewController() {
        let home = templateNavigationController(image: UIImage(systemName: "house")!, rootViewController: HomeVC())
        let manage = templateNavigationController(image: UIImage(systemName: "message")!, rootViewController: ChatVC())
        viewControllers = [home, manage]
        
    }
    
    func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationItem.largeTitleDisplayMode = .always
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }

}
