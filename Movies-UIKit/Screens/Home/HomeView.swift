//
//  HomeView.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

import UIKit
import SwiftUI

class HomeView: UIView {
    
    //MARK: - Properties
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
                
        return collectionView
    }()

    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()

    func configureCollectionViewLayout() {
        let cellWidth: CGFloat = 180
        let cellHeight: CGFloat = 300
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
    }
    
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .primaryYellow
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        return stackView
    }()
    
    lazy var titleAppLabel: UILabel = {
        let label = UILabel()
        label.text = "Movies"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var textField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondayYellow
        textField.placeholder = "Search"
        textField.textAlignment = .center
        
        return textField
    }()

    
    //MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupView()
        configureCollectionViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
//    @objc func goToRegisterAccount() {
//        coordinator?.start()
//        print("Sign Up works")
//    }
}

//MARK: - ViewCode
extension HomeView: ViewCoded {
    func buildViewHierarchy() {
        addSubview(headerStackView)
        headerStackView.addArrangedSubview(titleAppLabel)
        headerStackView.addArrangedSubview(textField)
        
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleAppLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleAppLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleAppLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -40),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 30),
            collectionView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ])
    }
    
    func addAdditionalConfiguration() {
        backgroundColor = .white
    }
}


