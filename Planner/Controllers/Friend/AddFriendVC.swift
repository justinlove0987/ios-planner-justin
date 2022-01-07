//
//  SearchFriendVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/13.
//

import UIKit
import JGProgressHUD

// MARK: - Protocol

protocol FriendDelegate {
    func addFriend(newFriend: Friend)
}

class AddFriendVC: UIViewController {
    
    // MARK: - Properties
    
    var friends: [Friend]?
    var delegate: FriendDelegate?
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var users = [[String: String]]()
    private var results = [[String: String]]()
    private var hasFetched = false
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let searchResult: SearchResultView = {
        let view = SearchResultView()
        view.isHidden = true
        view.backgroundColor = Color.white
        return view
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = Color.mainGreen
        label.font = .systemFont(ofSize:21, weight: .medium)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        self.title = "搜尋好友"
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = Color.mainBackground
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(didTapCancelBtn))
        self.navigationItem.leftBarButtonItem?.tintColor = Color.mainRed
        
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
        view.addSubview(searchResult)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.placeholder = "請輸入好友email"
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.textColor = Color.gray
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        searchResult.checkBtn.addTarget(self, action: #selector(didTapCheckBtn), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        searchResult.center(inView: view)
        searchResult.anchor(left: view.safeAreaLayoutGuide.leftAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor,
                            paddingLeft: 30,
                            paddingRight: 30)
        
        searchResult.setHeight(80)

        noResultLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
        
    }
    
    
    // MARK: - Actions
    @objc func didTapCancelBtn() {
        print("DEBUG: did tap cancel")
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapCheckBtn() {
        
        let targetUserData = results[0]
        guard let targetUserEmail = targetUserData["email"],
              let targetUserName = targetUserData["name"],
              let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                  return
              }
        let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        
        DatabaseManager.shared.addFriend(currentUserEmail: currentUserSafeEmail,
                                         targetUserEmail: targetUserEmail,
                                         targetUserName: targetUserName)
        
        self.delegate?.addFriend(newFriend: Friend(email: targetUserEmail,
                                                   name: targetUserName))
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - UITableViewDelegate

extension AddFriendVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetUserData = results[indexPath.row]
        print(targetUserData)
        guard let targetUserEmail = targetUserData["email"],
              let targetUserName = targetUserData["name"],
              let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                  return
              }
        
        let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        
        DatabaseManager.shared.addFriend(currentUserEmail: currentUserSafeEmail,
                                         targetUserEmail: targetUserEmail,
                                         targetUserName: targetUserName)
    }
    
}

// MARK: - UISearchBarDelegate

extension AddFriendVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text,
              !text.replacingOccurrences(of: " ", with: "").isEmpty else {
                  return
              }
        
        results.removeAll()
        spinner.show(in: view)
        
        self.searchUsers(query: text)
    }
    
    func searchUsers(query: String) {
        if hasFetched {
            filterUsers(with: query)
        } else {
            DatabaseManager.shared.getAllUsers { [weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            }
        }
    }
    
    func filterUsers(with term: String) {
        guard hasFetched,
              let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String,
              let friends = friends
        else  {
            return
        }
        
        self.spinner.dismiss()
        
        
        let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        var safeTerm = term.replacingOccurrences(of: ".", with: "-")
        safeTerm = safeTerm.replacingOccurrences(of: "@", with: "-").lowercased()
        
        // if user input is not self email
        guard safeTerm != currentUserSafeEmail else {
            alertMessage(message: "this is your email")
            return
        }
        
        // check friend id alreay exist
        let friendEmailArray: [String] = friends.compactMap { friend in
            return friend.email
        }
        guard friendEmailArray.contains(safeTerm) != true  else{
            alertMessage(message: "friend alreay exist")
            return
        }
        
        // search email from all users
        let results: [[String: String]] = self.users.filter({
            
            guard let email = $0["email"]?.lowercased() else {
                return false
            }
            
            return email == safeTerm
        })
        
        self.results = results
        
        self.searchResult.configure(with: safeTerm)
        updateUI()
    }
    
    
    func updateUI() {
        if results.isEmpty {
            self.noResultLabel.isHidden = false
            self.searchResult.isHidden = true
        }
        else {
            
            guard let name = self.results[0]["name"] else {
                return
            }
            self.noResultLabel.isHidden = true
            self.searchResult.nameLabel.text = name
            
            self.searchResult.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    private func alertMessage(message: String) {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
}
