//
//  ViewCoded.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

import Foundation

public protocol ViewCoded {
    func buildViewHierarchy()
    func setupConstraints()
    func addAdditionalConfiguration()
}

public extension ViewCoded {
    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        addAdditionalConfiguration()
    }
}
