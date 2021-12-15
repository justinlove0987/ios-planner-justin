//
//  ChatVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/10.
//

import UIKit

class ChatVC: UIViewController {
    
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.barStyle = .default
        searchBar.isTranslucent = true
        searchBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        searchBar.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return searchBar
    }()
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        self.title = "聊天"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.badge.plus"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didTapAddBtn))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    
    override func viewDidLayoutSubviews() {
           searchBar.centerX(inView: view)
           searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
           searchBar.setWidth(view.width)
           tableView.centerX(inView: view)
           tableView.anchor(top: searchBar.bottomAnchor,
                            left: view.leftAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingTop: 0,
                            paddingLeft: 0,
                            paddingBottom: 0,
                            paddingRight: 0)
       }
    
    // MARK: - Actions
    @objc func didTapAddBtn() {
        navigationController?.pushViewController(SearchFriendVC(), animated: true)
    }

    
    
}

extension ChatVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
}
