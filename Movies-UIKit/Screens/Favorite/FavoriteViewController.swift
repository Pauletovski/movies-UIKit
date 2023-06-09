//
//  FavoriteViewController.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/05/23.
//

import UIKit
import Combine
import SwiftUI

public class FavoriteViewController: UIViewController {
    
    //MARK: - Properties
    private var viewModel: FavoriteViewModel
    private var cancelSet = Set<AnyCancellable>()
    lazy private var contentView: FavoriteView = {
        FavoriteView()
    }()
    
    //MARK: - Init
    init(viewModel: FavoriteViewModel) {
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
        
        viewModel.onGenreFilterSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] genre in
                guard let self else { return }
                self.contentView.removeFilterButton.isHidden = false
                self.contentView.filterLabel.isHidden = false
                self.contentView.configureFilterLabel(text: genre.name)
                self.contentView.updateCollectionViewTopConstraintForFiltersOn()
            }.store(in: &viewModel.cancelSet)

    }
    
    //MARK: - Methods
    private func setupBindings() {
        contentView.onAddFilterTapped = {
            self.viewModel.coordinator.presentAddFilter()
        }
        
        contentView.onRemoveFilterTapped = {
            self.contentView.removeFilterButton.isHidden = true
            self.contentView.filterLabel.isHidden = true
            self.contentView.updateCollectionViewTopConstraint()
            self.viewModel.onFiltersRemoved.send()
        }
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

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private func setupCollectionView() {
        contentView.collectionView.register(MovieCard.self, forCellWithReuseIdentifier: MovieCard.identifier)
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredMovies.isEmpty ? viewModel.moviesFavorite.count : viewModel.filteredMovies.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentView.collectionView.dequeueReusableCell(withReuseIdentifier: MovieCard.identifier, for: indexPath) as! MovieCard
        
        let movie = viewModel.filteredMovies.isEmpty ? viewModel.moviesFavorite[indexPath.row] : viewModel.filteredMovies[indexPath.row]
        cell.configure(with: movie)
        
        cell.isFavorite = movie.isFavorite
        
        cell.onFavoriteButtonTapped = { [weak self] in
            guard let self else { return }
            
            self.viewModel.onFavoriteChanged.send(movie.id)
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.homeViewModel.onPresentMovieDetails.send(viewModel.filteredMovies.isEmpty ? viewModel.moviesFavorite[indexPath.row] : viewModel.filteredMovies[indexPath.row])
    }
}

extension FavoriteViewController: UITextFieldDelegate {
    
    private func setupTextField() {
        contentView.textField.delegate = self
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        if let searchText = textField.text, !searchText.isEmpty {
            viewModel.filteredMovies = viewModel.moviesFavorite.filter { $0.title.lowercased().contains(searchText.lowercased()) }
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
