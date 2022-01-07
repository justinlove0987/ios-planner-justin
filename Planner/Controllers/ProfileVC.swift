//
//  ProfileVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/17.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    
    // MARK: - Properties
    
    
    let sectionNames = ["基本資料", "其他"]
    
    let firstSectionTitles = ["username"]
    let firstSectionSymbols = ["person.circle.fill"]
    let firstSectionContents = [""]
    let firstSectionColors = [Color.mainGreen]
    
    // "評分", "star.fill", "", Color.mainPurple
    let secondSectionTitles = ["版本", "隱私權政策", "icon來源", "登出"]
    let secondSectionSymbols = ["info.circle.fill", "doc.fill", "link.circle.fill",  "escape"]
    let secondSectionContents = ["1.0", "", "", ""]
    let secondSectionColors = [Color.mainYellow, Color.mainBlue, Color.mainLightGreen, Color.mainRed]
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = Color.mainBackground
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        return table
    }()
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width / 2
        
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
        
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        self.title = "設定"
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = Color.mainBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.tableHeaderView = createTableHeader()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.centerX(inView: view)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor,
                         paddingTop: 0,
                         paddingLeft: 0,
                         paddingBottom: 0,
                         paddingRight: 0)
        
        userImageView.layer.cornerRadius = userImageView.width / 2.0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userImageView.image == nil {
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                return
            }
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            let filename = safeEmail + "_profile_picture.png"
            let path = "images/" + filename
            
            
            StorageManager.shared.downloadUrl(for: path) { [weak self] result in
                switch result {
                case .success(let url):
                    
                    if let _ = self?.userImageView {
                        self?.downloadImage(imageView: self!.userImageView, url: url)
                    } else {
                        return
                    }
                    
                case .failure(let error):
                    print("Failed to get download url: \(error)")
                    
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    // MARK: - Helpers
    
    func createTableHeader() -> UIView? {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/" + filename
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 200))
        headerView.backgroundColor = Color.mainBackground
        
        
        headerView.addSubview(userImageView)
        
        userImageView.center(inView: headerView)
        userImageView.setDimensions(height: 120, width: 120)
        
        StorageManager.shared.downloadUrl(for: path) { [weak self] result in
            switch result {
            case .success(let url):
                
                if let _ = self?.userImageView {
                    self?.downloadImage(imageView: self!.userImageView, url: url)
                } else {
                    return
                }
                
            case .failure(let error):
                print("Failed to get download url: \(error)")
                
            }
        }
        return headerView
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }).resume()
    }
    
    func changeUserName(cell: SettingTableViewCell) {
        
        guard let username = UserDefaults.standard.value(forKey: "name") as? String else {
            return
        }
        
        let alert = UIAlertController(title: "Username", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = username
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields![0],
               let newUserName = textField.text{
                cell.contentLabel.text = newUserName
                UserDefaults.standard.set(newUserName, forKey: "name")
                
                DatabaseManager.shared.changeUsername(newUserName: newUserName)
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return firstSectionTitles.count
        } else {
            return secondSectionTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        
        if indexPath == IndexPath(row: 0, section: 1) {
            cell.isUserInteractionEnabled = false
        }
        
        if indexPath.section == 0 {
            cell.symbol.image = UIImage(systemName: firstSectionSymbols[indexPath.row])
            cell.titleLabel.text = firstSectionTitles[indexPath.row]
            cell.contentLabel.text = firstSectionContents[indexPath.row]
            cell.symbol.tintColor = firstSectionColors[indexPath.row]
            
            if let name = UserDefaults.standard.value(forKey: "name") as? String {
                cell.contentLabel.text = "\(name)"
            }
            
            return cell
            
        } else {
            cell.symbol.image = UIImage(systemName: secondSectionSymbols[indexPath.row])
            cell.titleLabel.text = secondSectionTitles[indexPath.row]
            cell.contentLabel.text = secondSectionContents[indexPath.row]
            cell.symbol.tintColor = secondSectionColors[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == IndexPath(row: 3, section: 1) {
            let actionSheet = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "登出", style: .destructive, handler: { [weak self] _ in
                guard let stringSelf = self else { return }
                
                do {
                    try FirebaseAuth.Auth.auth().signOut()
                    let vc = LoginVC()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen // we don't want user to dismiss the log-in view
                    stringSelf.present(nav, animated: true)
                } catch {
                    print("Failed to log out")
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true)
            
        } else if indexPath == IndexPath(row: 2, section: 1) {
            let urlString = "https://www.flaticon.com/"
            // user -> Aldo Cervantes
            // challenge -> https://www.freepik.com
            guard let url = URL(string: urlString) else {
                return
            }
            UIApplication.shared.open(url, options: [:])
            
        } else if indexPath == IndexPath(row: 1, section: 1) {
            let urlString = "https://www.privacypolicies.com/live/51a4d85c-d696-4c9e-8439-6e4267a0937e"
            guard let url = URL(string: urlString) else {
                return
            }
            UIApplication.shared.open(url, options: [:])
            
        } else if indexPath == IndexPath(row: 0, section: 0) {
            let cell = tableView.cellForRow(at: indexPath) as! SettingTableViewCell
            
            changeUserName(cell: cell)
        }
        
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in self?.presnetCamera()})) // self become optional because of the weak modifier
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in self?.presentPhotoPicker()}))
        
        present(actionSheet, animated: true)
        
    }
    
    func presnetCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage  else { return }// editedImage -> the square one
        
        self.userImageView.image = selectedImage
        
        // upload to firebase
        guard let email = UserDefaults.standard.value(forKey: "email") as? String,
              let image = userImageView.image,
              let data = image.pngData() else {
                  return
              }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let fileName = "\(safeEmail)_profile_picture.png"
        
        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
            switch result {
            case .success(let downloadUrl):
                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                print(downloadUrl)
            case .failure(let error):
                print("Storage manageer error: \(error)")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

