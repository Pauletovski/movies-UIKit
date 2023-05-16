//
//  MovieDetailsViewController.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/05/23.
//

import UIKit

public class MovieDetailsViewController: UIViewController {
    
    //MARK: - Properties
    lazy var contentView: MovieDetailsView = {
        MovieDetailsView()
    }()
    
    private var viewModel: MovieDetailsViewModel
    
    //MARK: - Init
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
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
        setupBindings()
    }
    
    private func setupBindings() { }
}

extension MovieDetailsViewController: MovieDetailsViewModelDelegate {
    func didReceiveMovieDetails(movie: MovieViewData) {
        DispatchQueue.main.async {
            self.contentView.configure(with: movie)
        }
    }
}
