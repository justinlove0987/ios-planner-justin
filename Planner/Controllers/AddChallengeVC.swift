//
//  PlanSetterVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/10.
//

import UIKit

// MARK: - Protocols

protocol AddChallengeDelegate {
    func addChallenge(with challengeId: String,
                      uploadChallenges: AddChallenge,
                      myNewChallenge: MyChallenge)
}

class AddChallengeVC: UIViewController, InviteFriendDelegate {
    
    var delegate: AddChallengeDelegate?
    var invitedFriends = [InvitedFriendInformation]()
    
    // MARK: - Properties
    
    private let planNameTextField: UITextField = {
        let field = CustomAddChallengeTextField(placeholder: "挑戰名稱")
        field.keyboardType = UIKeyboardType.default
        return field
    }()
    
    private let unitTextField: UITextField = {
        let field = CustomAddChallengeTextField(placeholder: "挑戰量")
        field.keyboardType = UIKeyboardType.numberPad
        return field
    }()
    
    private let inviteBtn: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 7
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let inviteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "邀請好友"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let inviteImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "chevron.right")
        imgView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = #colorLiteral(red: 0.8931378126, green: 0.8983256221, blue: 0.8936956525, alpha: 1)
        title = "新增挑戰"
        
        
        let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title3),
                          NSAttributedString.Key.foregroundColor: Color.gray]
        
        navigationController?.navigationBar.titleTextAttributes = attributes

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
        
        
        view.addSubview(planNameTextField)
        view.addSubview(unitTextField)
        view.addSubview(inviteBtn)
        
        inviteBtn.addSubview(inviteLabel)
        inviteBtn.addSubview(inviteImgView)
        
        // addTarget
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapInviteBtn))
        gesture.numberOfTapsRequired = 1
        inviteBtn.addGestureRecognizer(gesture)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        planNameTextField.centerX(inView: view)
        planNameTextField.setHeight(60)
        planNameTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 paddingTop: 22,
                                 paddingLeft: 10,
                                 paddingRight: 10)
        planNameTextField.layer.cornerRadius = 7
        
        unitTextField.centerX(inView: view)
        unitTextField.setHeight(60)
        unitTextField.anchor(top: planNameTextField.bottomAnchor,
                             left: view.leftAnchor,
                             right: view.rightAnchor,
                             paddingTop: 22,
                             paddingLeft: 10,
                             paddingRight: 10)
        unitTextField.layer.cornerRadius = 7
        
        inviteBtn.centerX(inView: view)
        inviteBtn.setHeight(60)
        inviteBtn.anchor(top: unitTextField.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 10,
                         paddingRight: 10)
        
        
        inviteLabel.centerY(inView: inviteBtn)
        inviteLabel.setWidth(100)
        inviteLabel.anchor(top:inviteBtn.topAnchor,
                           left: inviteBtn.leftAnchor,
                           bottom: inviteBtn.bottomAnchor,
                           paddingTop: 10,
                           paddingLeft: 12,
                           paddingBottom: 10)
        
        inviteImgView.centerY(inView: inviteBtn)
        inviteImgView.anchor(right: inviteBtn.rightAnchor,
                             paddingRight: 12)
        
    }
    
    // MARK: - Actions
    @objc func didTapInviteBtn() {
        let vc = InviteVC()
        vc.delgate = self
        vc.invitedFriends = invitedFriends
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapCancelBtn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapConfirmBtn() {
        guard let challengeName = planNameTextField.text,
              !challengeName.replacingOccurrences(of: " ", with: "").isEmpty
        else {
            alertMessage(message: "請輸入挑戰名稱")
            return
        }
        
        guard let totalAmountString = unitTextField.text,
              let totalAmount = Int(totalAmountString),
              !totalAmountString.replacingOccurrences(of: " ", with: "").isEmpty
        else {
            alertMessage(message: "請輸入挑戰量")
            return
        }
        
        let date = Date()
        
        var isInvitedFriend = [InvitedFriendInformation]()
        
        for friend in invitedFriends {
            if friend.isInvited {
                isInvitedFriend.append(InvitedFriendInformation(email: friend.email,
                                                                name: friend.name,
                                                                isInvited: friend.isInvited))
            }
        }
        
        let uploadChallenge = AddChallenge(name: challengeName,
                                     date: date,
                                     totalAmount: totalAmount,
                                     currentProgress: 0,
                                     invitedFriendInformations: isInvitedFriend)
        
        
        let uuid = UUID().uuidString
        let newChallenge = MyChallenge(id: uuid,
                                       name: challengeName,
                                       date: date,
                                       currentProgress: 0,
                                       totalAmount: totalAmount)
        
        delegate?.addChallenge(with: uuid,
                               uploadChallenges: uploadChallenge,
                               myNewChallenge: newChallenge)
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    // InviteFriendDelegate
    func setInvitedFriends(email: String, name: String, isInvited: Bool) {
        
        for invitedFriend in invitedFriends {
            if email == invitedFriend.email {
                return
            }
        }
        
        invitedFriends.append(InvitedFriendInformation(email: email, name: name, isInvited: isInvited))
        
    }
    
    func getInvitedFriends() -> [InvitedFriendInformation] {
        return invitedFriends
    }
    
    func updateInvitedFriends(indexPath: IndexPath) {
        invitedFriends[indexPath.row].isInvited = !invitedFriends[indexPath.row].isInvited
    }
    
    private func alertMessage(message: String) {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
}
