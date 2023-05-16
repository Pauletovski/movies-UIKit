//
//  ViewController.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

import UIKit
import Combine
import SwiftUI

public class HomeViewController: UIViewController {
    
    //MARK: - Properties
    private var viewModel: HomeViewModel
    private var cancelSet = Set<AnyCancellable>()
    lazy private var contentView: HomeView = {
        HomeView()
    }()
    
    //MARK: - Init
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
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
        setup()
        configKeyboard()
        
        setupTextField()
        
        viewModel.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.contentView.collectionView.reloadData()
            }.store(in: &viewModel.cancelSet)
    }
    
    //MARK: - Methods
    private func setupBindings() {
        
    }
    
    private func setup() {
        setupBindings()
        setupCollectionView()
    }
    
    //MARK: - Keyboard
    
    func configKeyboard() {
        self.showKeyboardWhenTappedAround()
        self.hideKeyboardWhenTappedAround()
    }
}

    //MARK: - CollectionViewConfiguration

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private func setupCollectionView() {
        contentView.collectionView.register(MovieCard.self, forCellWithReuseIdentifier: MovieCard.identifier)
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredMovies.isEmpty ? viewModel.moviesResult.count : viewModel.filteredMovies.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentView.collectionView.dequeueReusableCell(withReuseIdentifier: MovieCard.identifier, for: indexPath) as! MovieCard
        
        let movie = viewModel.filteredMovies.isEmpty ? viewModel.moviesResult[indexPath.row] : viewModel.filteredMovies[indexPath.row]
        cell.configure(with: movie)
        
        cell.isFavorite = movie.isFavorite
        
        cell.onFavoriteButtonTapped = { [weak self] in
            guard let self else { return }
            
            self.viewModel.onFavoriteChanged.send(movie.id)
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.onPresentMovieDetails.send(viewModel.filteredMovies.isEmpty ? viewModel.moviesResult[indexPath.row] : viewModel.filteredMovies[indexPath.row])
    }
}

extension HomeViewController: UITextFieldDelegate {
    
    private func setupTextField() {
        contentView.textField.delegate = self
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        if let searchText = textField.text, !searchText.isEmpty {
            viewModel.filteredMovies = viewModel.moviesResult.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        } else {
            viewModel.filteredMovies = []
        }
        contentView.collectionView.reloadData()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
