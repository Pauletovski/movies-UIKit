//
//  CustomTableViewCell.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 18/05/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    static let identifier = "Cell"
    
    lazy var filterName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubview(filterName)
        NSLayoutConstraint.activate([
            filterName.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            filterName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            filterName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            filterName.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setupCell(text: String) {
        filterName.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
