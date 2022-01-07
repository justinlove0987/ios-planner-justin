//
//  ChatVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/10.
//

import UIKit

struct Friend {
    let email: String
    let name: String
}

class FriendVC: UIViewController, FriendDelegate {
    
    // MARK: - Properties
    
    private var friends = [Friend]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.identifier)
        tableView.backgroundColor = Color.mainBackground

        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        self.title = "好友"
        self.navigationItem.largeTitleDisplayMode = .never
        
        let addBtn = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.badge.plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(didTapAddBtn))
        addBtn.tintColor = Color.mainGreen
        
        self.navigationItem.rightBarButtonItems = [addBtn]
        view.backgroundColor = Color.mainBackground
        view.addSubview(tableView)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        
        
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.textColor = Color.gray
        
        loadFriendData()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        tableView.centerX(inView: view)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor,
                         paddingTop: 0,
                         paddingLeft: 0,
                         paddingBottom: 0,
                         paddingRight: 0)
    }
    
    // MARK: - Actions
    
    @objc func didTapAddBtn() {
        let vc = AddFriendVC()
        vc.friends = self.friends
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Database
    
    func loadFriendData() {
        DatabaseManager.shared.getFriends { [weak self] result in
            switch result {
            case .success(let friendInformations):
                
                let newFriends: [Friend] = friendInformations.compactMap { dictionary in
                    guard let name = dictionary["name"],
                          let email = dictionary["email"] else {
                              return nil
                          }
                    return Friend(email: email, name: name)
                }
                
                self?.friends = newFriends
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print("failed to get friend emails: \(error)")
            }
        }
    }
    
    // MARK: - Helpers
    
    func addFriend(newFriend: Friend) {
        friends.append(newFriend)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - UITableViewDataSource

extension FriendVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: indexPath) as! FriendTableViewCell
        
        let safeEmail = friends[indexPath.row].email
        let name = friends[indexPath.row].name
        
        cell.nameLabel.text = name
        cell.configureImageView(with: safeEmail)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            DatabaseManager.shared.deleteFriend(with: friends[indexPath.row].email)
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}


extension FriendVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
              !text.replacingOccurrences(of: " ", with: "").isEmpty else {
                  return
              }
    }
}
