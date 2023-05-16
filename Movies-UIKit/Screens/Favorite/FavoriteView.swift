//
//  FavoriteView.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/05/23.
//

import UIKit

final class FavoriteView: UIView {
    
    //MARK: - Properties
    
    var onAddFilterTapped: (() -> Void)?
    var onRemoveFilterTapped: (() -> Void)?
    
    private var collectionViewTopConstraint: NSLayoutConstraint?
    
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
    
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Filter", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        button.addTarget(self, action: #selector(addFilter), for: .touchUpInside)
        button.backgroundColor = .primaryGray
        button.tintColor = .white
        
        return button
    }()
    
    lazy var removeFilterButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Remove Filter", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        button.addTarget(self, action: #selector(removeFilter), for: .touchUpInside)
        button.backgroundColor = .systemRed
        button.tintColor = .white
        
        return button
    }()
    
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
        label.text = "Favorites"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .primaryYellow
        
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
        updateCollectionViewTopConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func addFilter() {
        self.onAddFilterTapped?()
    }
    
    @objc func removeFilter() {
        self.onRemoveFilterTapped?()
    }
    
    func updateCollectionViewTopConstraint() {
        collectionViewTopConstraint?.constant = 10
    }
    
    func updateCollectionViewTopConstraintForFiltersOn() {
        collectionViewTopConstraint?.constant = 80
    }
    
    func configureFilterLabel(text: String) {
        filterLabel.text = text
    }
}

//MARK: - ViewCode
extension FavoriteView: ViewCoded {
    func buildViewHierarchy() {
        addSubview(headerStackView)
        headerStackView.addArrangedSubview(titleAppLabel)
        headerStackView.addArrangedSubview(textField)
        
        addSubview(filterLabel)
        addSubview(filterButton)
        addSubview(removeFilterButton)
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 10)
        collectionViewTopConstraint?.isActive = true
        
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
            
            filterButton.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            removeFilterButton.topAnchor.constraint(equalTo: filterButton.bottomAnchor),
            removeFilterButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            removeFilterButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            filterLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterLabel.topAnchor.constraint(equalTo: removeFilterButton.bottomAnchor),
            
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ])
    }

    func addAdditionalConfiguration() {
        backgroundColor = .white
        removeFilterButton.isHidden = true
        filterLabel.isHidden = true
    }
}
