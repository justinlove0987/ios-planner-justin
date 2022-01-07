//
//  HomeVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/10.
//

import UIKit
import FirebaseAuth
import JGProgressHUD


class HomeVC: UIViewController, AddChallengeDelegate, ChallengeDelegate, LoginDelegate {
    
    private var myChallenges = [MyChallenge]()
    private var challengeIds = [String]()
    private var isStartListeningDatas = false
    
    // MARK: - Properties
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.sectionFooterHeight = 10
        tableView.backgroundColor = Color.mainBackground
        tableView.isHidden = true
        return tableView
    }()
    
    private let addChallengeBtn: UIButton =  {
        let btn = UIButton()
        btn.layer.shadowRadius = 10
        btn.layer.shadowOpacity = 0.3
        btn.layer.cornerRadius = 25
        btn.backgroundColor = #colorLiteral(red: 0.3481204808, green: 0.680793047, blue: 0.8822361231, alpha: 1)
        btn.tintColor = .white
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium))
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    private let squareAddChallengeView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9631707072, green: 0.8049247265, blue: 0.383543551, alpha: 1)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.layer.borderWidth = 1.0
        view.isHidden = true
        return view
    }()
    
    private let squareAddChallegeMask: UIView = {
        let view = UIView()
        view.backgroundColor = Color.mainBlue
        return view
    }()
    
    private let squareAddChallengeImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.tintColor = .white
        imgView.image = UIImage(systemName: "plus",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .bold))
        return imgView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "挑戰"
        view.backgroundColor = Color.mainBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(squareAddChallengeView)
        view.addSubview(addChallengeBtn)
        squareAddChallengeView.addSubview(squareAddChallegeMask)
        squareAddChallengeView.addSubview(squareAddChallengeImageView)
        
        // Actions
        addChallengeBtn.addTarget(self, action: #selector(didTapAddChallengeBtn), for: .touchUpInside)
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTempAddChalengeBtn))
        gesture.numberOfTapsRequired = 1
        squareAddChallegeMask.addGestureRecognizer(gesture)
        
        startListeningChallengeDatas()
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.centerX(inView: view)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 20,
                         paddingBottom: 20,
                         paddingRight: 20)
        tableView.layer.cornerRadius = 7
        
        squareAddChallengeView.centerX(inView: view)
        squareAddChallengeView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                    left: view.leftAnchor,
                                    right: view.rightAnchor,
                                    paddingTop: 20,
                                    paddingLeft: 30,
                                    paddingRight: 30)
        squareAddChallengeView.setHeight(100)
        
        let point1 = CGPoint(x: squareAddChallengeView.frame.minX, y: squareAddChallengeView.frame.minY)
        let point2 = CGPoint(x: squareAddChallengeView.frame.minX, y: squareAddChallengeView.frame.maxY)
        let point3 = CGPoint(x: squareAddChallengeView.frame.maxX, y: squareAddChallengeView.frame.minY)
        
        let trianglePath = UIBezierPath()
        trianglePath.move(to: point1)
        trianglePath.addLine(to: point2)
        trianglePath.addLine(to: point3)
        trianglePath.close()
        
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = trianglePath.cgPath
        squareAddChallegeMask.layer.mask = triangleLayer
        
        squareAddChallegeMask.anchor(top: view.topAnchor,
                                   left: view.leftAnchor,
                                   bottom: view.bottomAnchor,
                                   right: view.rightAnchor,
                                   paddingTop: 0,
                                   paddingLeft: 0,
                                   paddingBottom: 0,
                                   paddingRight: 0
                                   
        )
        
        
        squareAddChallengeImageView.center(inView: squareAddChallengeView)
        squareAddChallengeImageView.setDimensions(height: 50, width: 50)
        
        addChallengeBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               right: view.safeAreaLayoutGuide.rightAnchor,
                               paddingBottom: 20,
                               paddingRight: 20)
        addChallengeBtn.setDimensions(height: 50, width: 50)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        if isStartListeningDatas == false {
            startListeningChallengeDatas()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        validateAuth()
    }
    
    // MARK: - Actions
    
    @objc func didTapAddChallengeBtn() {
        let vc = AddChallengeVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapTempAddChalengeBtn() {
        let vc = AddChallengeVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Database
    
    func startListeningChallengeDatas() {
        DatabaseManager.shared.getCurrentUserChallengeInformations { result in
            switch result {
            case .success(let userChallengeInformations):
                
                self.isStartListeningDatas = true
                
                self.myChallenges = userChallengeInformations
                
                if self.myChallenges.count == 0 {
                    self.tableView.isHidden = true
                    self.squareAddChallengeView.isHidden = false
                    self.addChallengeBtn.isHidden = true
                    
                } else {
                    self.tableView.isHidden = false
                    self.squareAddChallengeView.isHidden = true
                    self.addChallengeBtn.isHidden = false
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            case .failure(let error):
                self.tableView.isHidden = true
                self.squareAddChallengeView.isHidden = false
                self.addChallengeBtn.isHidden = true
                print("failed to get challenges: \(error)")
            }
        }
    }
    
    func addChallenge(with challengeId: String, uploadChallenges: AddChallenge, myNewChallenge: MyChallenge) {
        DispatchQueue.main.async {
            self.myChallenges.append(myNewChallenge)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // upload to Firebase
        DatabaseManager.shared.addChallenge(with: challengeId, challenge: uploadChallenges)
        
    }
    

    
    // MARK: - Helpers
    
    func updateMyChallenge(challenge: MyChallenge, indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.myChallenges[indexPath.row] = challenge
            self.tableView.reloadRows(at: [indexPath], with: .top)
        }
    }
    
    private func validateAuth() {
        if let currentUser = FirebaseAuth.Auth.auth().currentUser {
            guard let email = currentUser.email else {
                print("failed to get currrentUser email")
                showLoginVC()
                return
            }
            DatabaseManager.shared.setUserDefaults(with: email)
        } else {
            showLoginVC()
        }
    }
    
    private func showLoginVC() {
        let vc = LoginVC()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen // we don't want user to dismiss the log-in view
        present(nav, animated: false)
    }
    
}

// MARK: - UITableViewDataSource

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myChallenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
        
        let percentage = Double(myChallenges[indexPath.row].currentProgress) / Double(myChallenges[indexPath.row].totalAmount)
        
        cell.challengetName.text = myChallenges[indexPath.row].name
        cell.selectionStyle = .none
        cell.backView.progress = percentage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ShowChallengeVC()
        vc.challengeId = myChallenges[indexPath.row].id
        vc.delegate = self
        vc.myChallenge = myChallenges[indexPath.row]
        vc.indexPath = indexPath
        vc.title = myChallenges[indexPath.row].name
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            // update firebase
            DatabaseManager.shared.deleteChallenge(with: myChallenges[indexPath.row].id)
            
            myChallenges.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
}
