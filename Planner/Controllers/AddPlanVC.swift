//
//  PlanSetterVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/10.
//

import UIKit

class AddPlanVC: UIViewController {
    
    private let planNameTextField: UITextField = {
        let field = UITextField()
        let spacer = UIView()
        field.backgroundColor = .white
        field.placeholder = "任務名稱"
        field.leftViewMode = .always
        spacer.setDimensions(height: 52, width: 12)
        field.leftView = spacer
        return field
    }()
    
    private let repeatView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let repeatLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "重複"
        return label
    }()
    
    private let repeatSwitch: UISwitch = {
        let repeatSwitch = UISwitch()
        repeatSwitch.isOn = false
        return repeatSwitch
    }()
    
    
    private let endDateView: DateView = {
        let dateview = DateView()
        dateview.titleLabel.text = "結束"
        return dateview
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = #colorLiteral(red: 0.8979603648, green: 0.8980898261, blue: 0.8979322314, alpha: 1)
        return view
    }()
    
    private let startAndEndDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let unitTextField: UITextField = {
        let field = UITextField()
        let spacer = UIView()
        field.backgroundColor = .white
        field.placeholder = "每天量"
        field.leftViewMode = .always
        spacer.setDimensions(height: 52, width: 12)
        field.leftView = spacer
        return field
    }()
    
    private let inviteBtn: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let inviteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "邀請"
        return label
    }()
    
    private let inviteImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "chevron.right")
        imgView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = #colorLiteral(red: 0.8931378126, green: 0.8983256221, blue: 0.8936956525, alpha: 1)
        title = "新增任務"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(didTapCancelBtn))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "確定",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didTapCancelBtn))
        
        
        
        view.addSubview(planNameTextField)
        
        view.addSubview(startAndEndDateStackView)
        startAndEndDateStackView.addArrangedSubview(repeatView)
        startAndEndDateStackView.addArrangedSubview(endDateView)
        startAndEndDateStackView.addSubview(lineView)
        
        view.addSubview(unitTextField)
        view.addSubview(inviteBtn)
        
        inviteBtn.addSubview(inviteLabel)
        inviteBtn.addSubview(inviteImgView)
        
        repeatView.addSubview(repeatLabel)
        repeatView.addSubview(repeatSwitch)
        
        // addTarget
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapInviteBtn))
        gesture.numberOfTapsRequired = 1
        inviteBtn.addGestureRecognizer(gesture)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        planNameTextField.centerX(inView: view)
        planNameTextField.setHeight(52)
        planNameTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 paddingTop: 22,
                                 paddingLeft: 10,
                                 paddingRight: 10)
        planNameTextField.layer.cornerRadius = 7
        
        startAndEndDateStackView.centerX(inView: view)
        startAndEndDateStackView.setHeight(106)
        startAndEndDateStackView.anchor(top: planNameTextField.bottomAnchor,
                                        left: view.leftAnchor,
                                        right: view.rightAnchor,
                                        paddingTop: 22,
                                        paddingLeft: 10,
                                        paddingRight: 10)
        startAndEndDateStackView.layer.cornerRadius = 7
        lineView.centerY(inView: startAndEndDateStackView)
        lineView.setHeight(1)
        lineView.anchor(left: startAndEndDateStackView.leftAnchor,
                        right: startAndEndDateStackView.rightAnchor,
                        paddingLeft: 17,
                        paddingRight: 17)
        
        unitTextField.centerX(inView: view)
        unitTextField.setHeight(50)
        unitTextField.anchor(top: startAndEndDateStackView.bottomAnchor,
                             left: view.leftAnchor,
                             right: view.rightAnchor,
                             paddingTop: 22,
                             paddingLeft: 10,
                             paddingRight: 10)
        unitTextField.layer.cornerRadius = 7
        
        inviteBtn.centerX(inView: view)
        inviteBtn.setHeight(50)
        inviteBtn.anchor(top: unitTextField.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 10,
                         paddingRight: 10)
        inviteBtn.layer.cornerRadius = 7
        
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
        
        repeatLabel.centerY(inView: repeatView)
        repeatLabel.setWidth(100)
        repeatLabel.anchor(top:repeatView.topAnchor,
                           left: repeatView.leftAnchor,
                           bottom: repeatView.bottomAnchor,
                           paddingTop: 10,
                           paddingLeft: 12,
                           paddingBottom: 10)
        
        repeatSwitch.centerY(inView: repeatView)
        repeatSwitch.anchor(right: repeatView.rightAnchor,
                            paddingRight: 12)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Actions
    
    @objc func didTapInviteBtn() {
        navigationController?.pushViewController(InviteFriendVC(), animated: true)
    }
    
    @objc func didTapCancelBtn() {
        print("DEBUG: did tap cancel")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapConfirmBtn() {
        print("DEBUG: did tap confirm")
        navigationController?.popViewController(animated: true)
    }
    
}
