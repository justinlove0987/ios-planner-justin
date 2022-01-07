//
//  InviteVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/13.
//

import UIKit

// MARK: - Protocols

protocol InviteFriendDelegate {
    func setInvitedFriends(email: String, name: String, isInvited: Bool)
    func updateInvitedFriends(indexPath: IndexPath)
    func getInvitedFriends() -> [InvitedFriendInformation]
}

class InviteVC: UIViewController {
    
    // MARK: - Properties
    
    var delgate: InviteFriendDelegate?
    var invitedFriends: [InvitedFriendInformation]?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var friendInformations = [[String: String]]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(InviteFriendTableViewCell.self, forCellReuseIdentifier: InviteFriendTableViewCell.identifier)
        tableView.backgroundColor = Color.mainBackground
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        self.title = "選擇好友"
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = Color.mainBackground
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(didTapCancelBtn))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle.fill"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didTapConfirmBtn))
        
        self.navigationItem.leftBarButtonItem?.tintColor = Color.mainRed
        self.navigationItem.rightBarButtonItem?.tintColor = Color.mainGreen
        
        view.addSubview(tableView)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        
        
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.textColor = Color.gray
        
        DatabaseManager.shared.getFriends { [weak self] result in
            switch result { 
            case .success(let friendInformations):
                self?.friendInformations = friendInformations
                
                for friendInformation in friendInformations {
                    
                    guard let email = friendInformation["email"],
                          let name = friendInformation["name"] else {
                              return
                          }
                    
                    self?.delgate?.setInvitedFriends(email: email, name: name, isInvited: false)
                }
                
                let invitedFriendData = self?.delgate?.getInvitedFriends()
                self?.invitedFriends = invitedFriendData
                
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("failed to get friend emails: \(error)")
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        tableView.centerX(inView: view)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor,
                         paddingTop: 0,
                         paddingLeft: 0,
                         paddingBottom: 0,
                         paddingRight: 0)
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


// MARK: - UITableViewDataSource

extension InviteVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitedFriends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InviteFriendTableViewCell.identifier, for: indexPath) as! InviteFriendTableViewCell
        
        if let invitedFriends = invitedFriends {
            let safeEmail = invitedFriends[indexPath.row].email
            let name = invitedFriends[indexPath.row].name
            cell.nameLabel.text = name
            cell.configureImageView(with: safeEmail)
            if invitedFriends[indexPath.row].isInvited == true {
                cell.checkbox.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                cell.checkbox.image = UIImage(systemName: "circle")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? InviteFriendTableViewCell {
            DispatchQueue.main.async {
                self.updateUI(cell: cell)
            }
        }
        
        self.delgate?.updateInvitedFriends(indexPath: indexPath)
        
            
    }
    
    private func updateUI(cell: InviteFriendTableViewCell) {
        if cell.checkbox.image == UIImage(systemName: "checkmark.circle.fill") {
            cell.checkbox.image = UIImage(systemName: "circle")
        } else {
            cell.checkbox.image = UIImage(systemName: "checkmark.circle.fill")
        }
    }
    
}

extension InviteVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
                !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
    }
}
