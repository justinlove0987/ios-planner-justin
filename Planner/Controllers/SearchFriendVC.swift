//
//  SearchFriendVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/13.
//

import UIKit

class SearchFriendVC: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.barStyle = .default
        searchBar.isTranslucent = true
        searchBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        searchBar.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        self.title = "選擇好友"
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(didTapCancelBtn))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "確認",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didTapConfirmBtn))
        
        view.addSubview(searchBar)

    }
    
    override func viewDidLayoutSubviews() {
        searchBar.centerX(inView: view)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        searchBar.setWidth(view.width)
    }
    
    // MARK: - Actions
    @objc func didTapCancelBtn() {
        print("DEBUG: did tap cancel")
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func didTapConfirmBtn() {
        print("DEBUG: did tap cancel")
        navigationController?.popViewController(animated: true)
    }
    


}
