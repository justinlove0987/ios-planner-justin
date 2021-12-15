//
//  HomeVC.swift
//  Planner
//
//  Created by 曾柏瑒 on 2021/12/10.
//

import UIKit

class HomeVC: UIViewController {

    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "今日"
        label.font = label.font.withSize(30)
        return label
    }()
    
    private var collectionView: UICollectionView!
    private let collectionViewFlowLayout: UICollectionViewFlowLayout =  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }()
    
    private let addFllowerButton: UIButton =  {
        let btn = UIButton()
        btn.setDimensions(height: 40, width: 40)
        btn.layer.shadowRadius = 10
        btn.layer.shadowOpacity = 0.3
        btn.layer.cornerRadius = 20
        btn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        btn.tintColor = .white
        let image = UIImage(systemName: "person.badge.plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium))
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    
    private let addPlanBtn: UIButton =  {
        let btn = UIButton()
        btn.setDimensions(height: 40, width: 40)
        btn.layer.shadowRadius = 10
        btn.layer.shadowOpacity = 0.3
        btn.layer.cornerRadius = 20
        btn.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        btn.tintColor = .white
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium))
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(titleLabel)
        view.addSubview(addPlanBtn)

        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(collectionView)
        
        // Actions
        addPlanBtn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          paddingTop: 32,
                          paddingLeft: 32)
        
        addPlanBtn.centerY(inView: titleLabel)
        addPlanBtn.anchor(right: view.rightAnchor, paddingRight: 37)
        
        collectionView.centerX(inView: view)
        collectionView.anchor(top: addPlanBtn.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 22,
                              paddingLeft: 17,
                              paddingBottom: 22,
                              paddingRight: 17)
        collectionView.layer.cornerRadius = 7

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        
    }
    
    // MARK: - Actions
    
    @objc func didTapButton() {
        navigationController?.pushViewController(AddPlanVC(), animated: true)
    }

}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        cell.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ShowPlanVC()
        vc.progress = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: 80)
    }
       
}

