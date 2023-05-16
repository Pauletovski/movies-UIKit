//
//  AddFiltersView.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 18/05/23.
//

import UIKit
import Nuke

class AddFiltersView: UIView {
    
    //MARK: - Properties
    
    var onDismissTapped: (() -> Void)?
    
    lazy var headerView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .primaryYellow
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        
        return stackView
    }()
    
    lazy var filterDismiss: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        button.tintColor = .primaryGray
        
        return button
    }()
    
    lazy var filterTitle: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Genres"
        label.textColor = .primaryGray
        
        return label
    }()
    
    lazy var genreList: UITableView = {
        let tableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let spacer = UIView()

    
    //MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func dismissScreen() {
        onDismissTapped?()
    }
}

//MARK: - ViewCode
extension AddFiltersView: ViewCoded {
    func buildViewHierarchy() {
        addSubview(headerView)
        headerView.addArrangedSubview(filterDismiss)
        headerView.addArrangedSubview(filterTitle)
        headerView.addArrangedSubview(spacer)
        addSubview(genreList)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            filterDismiss.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            
            filterTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            genreList.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            genreList.leadingAnchor.constraint(equalTo: leadingAnchor),
            genreList.trailingAnchor.constraint(equalTo: trailingAnchor),
            genreList.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func addAdditionalConfiguration() {
        backgroundColor = .white
    }
}
