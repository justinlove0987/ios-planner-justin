//
//  ShowPlanVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/10.
//

import UIKit

// MARK: - Protocols

protocol ChallengeDelegate {
    func updateMyChallenge(challenge: MyChallenge, indexPath: IndexPath)
}

class ShowChallengeVC: UIViewController {
    
    // MARK: - Properties
    
    var delegate: ChallengeDelegate?
    var myChallenge: MyChallenge?
    var indexPath: IndexPath?
    
    private var otherMemberChallengeDatas = [MemberInformation]()
    private var myChallengeData = MemberInformation(email: "", name: "", totalAmount: 0, currentProgress: 0, isJoined: false)
    
    var challengeId: String? {
        didSet {
            if let id = challengeId {
                startListieningForMemberChallengeInformation(with: id)
            }
        }
    }
    
    private let myView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 7
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.layer.borderWidth = 1.0
        return view
    }()
    
    private let crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "crown.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = Color.mainYellow
        imageView.isHidden = true
        return imageView
    }()
    
    private let circularProgressBar: CircularProgressBar = {
        let progressbar = CircularProgressBar()
        return progressbar
    }()
    
    private let myDataLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor  = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        return label
    }()
    
    private let btnStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return stackView
    }()
    
    private let dataView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let addBtn: UIButton = {
        let btn = CustomShowChallengeButton(imageSystemName: "chevron.up")
        return btn
    }()
    
    private let subtractBtn: UIButton = {
        let btn = CustomShowChallengeButton(imageSystemName: "chevron.down")
        return btn
    }()
    
    private let doneBtn: UIButton = {
        let btn = CustomShowChallengeButton(imageSystemName: "checkmark")
        return btn
    }()
    
    private var collectionView: UICollectionView!
    private let collectionViewFlowLayout: UICollectionViewFlowLayout =  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = #colorLiteral(red: 0.9386649728, green: 0.9387997985, blue: 0.9386354685, alpha: 1)
        
        view.addSubview(myView)
        myView.addSubview(btnStackView)
        myView.addSubview(dataView)
        myView.addSubview(crownImageView)
        
        dataView.addSubview(circularProgressBar)
        dataView.addSubview(myDataLabel)
        
        btnStackView.addArrangedSubview(addBtn)
        btnStackView.addArrangedSubview(subtractBtn)
        btnStackView.addArrangedSubview(doneBtn)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView?.register(ShowChallengeCollectionViewCell.self, forCellWithReuseIdentifier: ShowChallengeCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = #colorLiteral(red: 0.9386649728, green: 0.9387997985, blue: 0.9386354685, alpha: 1)
        view.addSubview(collectionView)
        
        addBtn.addTarget(self, action: #selector(didTapAddBtn), for: .touchUpInside)
        subtractBtn.addTarget(self, action: #selector(didTapSubtractBtn), for: .touchUpInside)
        doneBtn.addTarget(self, action: #selector(didTapDoneBtn), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        myView.centerX(inView: view)
        myView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                      left: view.safeAreaLayoutGuide.leftAnchor,
                      right: view.safeAreaLayoutGuide.rightAnchor,
                      paddingTop: 30,
                      paddingLeft: 15,
                      paddingRight: 15
        )
        myView.setDimensions(height: 250, width: 300)
        
        crownImageView.centerX(inView: view)
        crownImageView.anchor(top: myView.topAnchor, paddingTop: 15)
        
        btnStackView.centerY(inView: myView)
        btnStackView.anchor(right:myView.rightAnchor, paddingRight: 20)
        btnStackView.setDimensions(height: 130, width: 130)
        
        dataView.anchor(left: myView.leftAnchor,
                        paddingLeft: 20
        )
        dataView.centerY(inView: btnStackView)
        
        dataView.centerY(inView: btnStackView)
        dataView.setDimensions(height: 150, width: 150)
        
        circularProgressBar.centerX(inView: dataView)
        circularProgressBar.anchor(top: dataView.topAnchor,
                                   paddingTop: 0)
        circularProgressBar.setDimensions(height: 110, width: 110)
        
        myDataLabel.centerX(inView: dataView)
        myDataLabel.anchor(top: circularProgressBar.bottomAnchor,
                           paddingTop: 5)
        myDataLabel.setDimensions(height: 40, width: 130)
        
        
        collectionView.centerX(inView: view)
        collectionView.anchor(top: myView.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 20,
                              paddingLeft: 15,
                              paddingBottom: 20,
                              paddingRight: 15
        )
        collectionView.layer.cornerRadius = 7
    }
    
    
    //MARK: - Actions
    
    @objc func didTapAddBtn(sender: UIButton) {
        guard let myChallenge = myChallenge else { return }
        
        if myChallenge.currentProgress < myChallenge.totalAmount {
            // update firebase
            guard let id = self.challengeId else {
                print("failed to get challengeId")
                return
            }
            DatabaseManager.shared.addCurrentProgress(with: id)
            calculateMyChallenge(sign: "+")
        }
    }
    
    
    @objc func didTapSubtractBtn() {
        guard let myChallenge = myChallenge else { return }
        
        if myChallenge.currentProgress > 0 {
            
            // update firebase
            guard let id = self.challengeId else {
                print("failed to get challengeId")
                return
            }
            DatabaseManager.shared.subtractCurrentProgress(with: id)
            calculateMyChallenge(sign: "-")
        }
    }
    
    
    @objc func didTapDoneBtn() {
        guard let _ = myChallenge else { return }
        // update firebase
        guard let id = self.challengeId else {
            print("failed to get challengeId")
            return
        }
        DatabaseManager.shared.completeCurrentProgress(with: id)
        calculateMyChallenge(sign: "=")
    }
    
    // MARK: - Database
    
    private func startListieningForMemberChallengeInformation(with id: String) {
        DatabaseManager.shared.getMemberInformation(with: id) { result in
            switch result {
            case .success(let memberInfomations):
                guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                    return
                }
                let currentUserSafeEmail = DatabaseManager.safeEmail(emailAddress: email)
                
                self.otherMemberChallengeDatas = [MemberInformation]()
                
                for memberInformation in memberInfomations {
                    if memberInformation.email == currentUserSafeEmail {
                        self.myChallengeData = memberInformation
                    } else {
                        self.otherMemberChallengeDatas.append(memberInformation)
                    }
                }

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.updateMyChallengeUI()
                }
                
            case .failure(let error):
                print("failed to get member informations: \(error)")
            }
        }
    }
    
    // MARK: - Helpers
    
    private func updateMyChallengeUI() {
        guard let myChallenge = myChallenge else { return }
        
        let percentage = Double(myChallenge.currentProgress) / Double(myChallenge.totalAmount)
        circularProgressBar.progress = percentage
        myDataLabel.text = "\(myChallenge.currentProgress)  /  \(myChallenge.totalAmount)"
        
        if myChallenge.currentProgress == myChallenge.totalAmount{
            crownImageView.isHidden = false
        } else {
            crownImageView.isHidden = true
        }
    }
    
    
    private func calculateMyChallenge(sign: String) {
        if var challenge = myChallenge,
            let i = indexPath {
            
            switch sign {
                case "+":
                    challenge.currentProgress += 1
                case "-":
                    challenge.currentProgress -= 1
                case "=":
                    challenge.currentProgress = challenge.totalAmount
                default:
                    return
            }
            
            myChallenge = challenge
            delegate?.updateMyChallenge(challenge: challenge, indexPath: i)
        }
        
        DispatchQueue.main.async {
            self.updateMyChallengeUI()
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension ShowChallengeVC: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherMemberChallengeDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowChallengeCollectionViewCell.identifier, for: indexPath) as! ShowChallengeCollectionViewCell
        
        let currentProgress = otherMemberChallengeDatas[indexPath.row].currentProgress
        let totalAmount = otherMemberChallengeDatas[indexPath.row].totalAmount
        let percentage = Double(currentProgress) / Double(totalAmount)
        
        print("percentage: \(percentage)")
        
        cell.nameLabel.text = otherMemberChallengeDatas[indexPath.row].name
        cell.customProgressBar.progress = percentage
        cell.otherUserDataLabel.text = "\(currentProgress) / \(totalAmount)"
        cell.configureImageView(with: otherMemberChallengeDatas[indexPath.row].email)
        
        if currentProgress == totalAmount {
            cell.crownImageView.isHidden = false
        } else {
            cell.crownImageView.isHidden = true
        }
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: myView.width, height: 70)
    }
    
    
    
}
