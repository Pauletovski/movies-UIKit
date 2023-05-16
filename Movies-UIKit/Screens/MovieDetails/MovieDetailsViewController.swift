//
//  MovieDetailsViewController.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/05/23.
//

import UIKit
import Combine
import SwiftUI

public class MovieDetailsViewController: UIViewController {
    
    //MARK: - Properties
    private var cancelSet = Set<AnyCancellable>()
    lazy var contentView: MovieDetailsView = {
        MovieDetailsView()
    }()
    
    //MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    public override func loadView() {
        super.loadView()
        view = contentView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}
