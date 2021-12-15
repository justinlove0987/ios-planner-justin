//
//  ShowPlanVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/10.
//

import UIKit

class ShowPlanVC: UIViewController {
    
    var progress: Int?
    
    private let myView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return view
    }()
    
    private let circularProgressBar: CustomCircularProgressBar = {
       let progressbar = CustomCircularProgressBar()
        return progressbar
    }()
    
    private let btnStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        return stackView
    }()
    
    private let addBtn: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        btn.layer.cornerRadius = 7
        return btn
    }()
    
    private let subtractBtn: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        btn.layer.cornerRadius = 7
        return btn
    }()
    
    private let doneBtn: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        btn.layer.cornerRadius = 7
        return btn
    }()
    
    private var collectionView: UICollectionView!
    private let collectionViewFlowLayout: UICollectionViewFlowLayout =  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        self.title = "運動"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = #colorLiteral(red: 0.8931378126, green: 0.8983256221, blue: 0.8936956525, alpha: 1)
        
        view.addSubview(myView)
        myView.addSubview(circularProgressBar)
        myView.addSubview(btnStackView)
        btnStackView.addArrangedSubview(addBtn)
        btnStackView.addArrangedSubview(subtractBtn)
        btnStackView.addArrangedSubview(doneBtn)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView?.register(ShowPlanCustomCell.self, forCellWithReuseIdentifier: ShowPlanCustomCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = #colorLiteral(red: 0.8979603648, green: 0.8980898261, blue: 0.8979322314, alpha: 1)
        view.addSubview(collectionView)
        
        
    }
    

    
    override func viewDidLayoutSubviews() {
        
        myView.centerX(inView: view)
        myView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        myView.setDimensions(height: 250, width: 300)
        circularProgressBar.centerY(inView: myView)
        circularProgressBar.anchor(left:myView.leftAnchor, paddingLeft: 20)
        circularProgressBar.setDimensions(height: 130, width: 130)
        btnStackView.centerY(inView: myView)
        btnStackView.anchor(right:myView.rightAnchor, paddingRight: 20)
        btnStackView.setDimensions(height: 130, width: 130)
        
        addBtn.anchor(
            left: btnStackView.leftAnchor,
            right: btnStackView.rightAnchor,
            paddingLeft: 20)
        
        subtractBtn.anchor(
            left: btnStackView.leftAnchor,
            right: btnStackView.rightAnchor,
            paddingLeft: 20)
        
        doneBtn.anchor(
            left: btnStackView.leftAnchor,
            right: btnStackView.rightAnchor,
            paddingLeft: 20)
        
        
        collectionView.centerX(inView: view)
        collectionView.anchor(top: myView.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 20,
                              paddingLeft: 10,
                              paddingBottom: 20,
                              paddingRight: 10)
        collectionView.layer.cornerRadius = 7
    }
    
}

extension ShowPlanVC: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowPlanCustomCell.identifier, for: indexPath) as! ShowPlanCustomCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: myView.width, height: 70)
    }

    
    
}
