//
//  MainTabBarController.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/10.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }
    
    
    // MARK: - Helpers
    
    func configureViewController() {
        let home = templateNavigationController(
            image: UIImage(systemName: "house")!,
            selectedImage: UIImage(systemName: "house.fill")!,
            title: "主頁",
            rootViewController: HomeVC())
        
        let manage = templateNavigationController(
            image: UIImage(systemName: "person.2")!,
            selectedImage: UIImage(systemName: "person.2.fill")!,
            title: "聊天",
            rootViewController: FriendVC())
        
        let profile = templateNavigationController(
            image: UIImage(systemName: "gearshape")!,
            selectedImage: UIImage(systemName: "gearshape.fill")!,
            title: "設定",
            rootViewController: ProfileVC())
        
        self.tabBar.tintColor = .black
        viewControllers = [home, manage, profile]
        
    }
    
    func templateNavigationController(image: UIImage, selectedImage: UIImage, title: String, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationItem.largeTitleDisplayMode = .always
        nav.navigationBar.prefersLargeTitles = true
        nav.title = title
        nav.navigationBar.isTranslucent = true
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: Color.gray]
        nav.navigationBar.largeTitleTextAttributes = textAttributes
        nav.navigationBar.titleTextAttributes = textAttributes
        
        return nav
    }

}
