//
//  ViewController.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

import UIKit

public class HomeViewController: UIViewController {
    
    //MARK: - Properties
    private var viewModel: HomeViewModelType
    lazy private var contentView: HomeView = {
        HomeView()
    }()
    
    //MARK: - Init
    init(viewModel: HomeViewModel) {
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
        setup()
        configKeyboard()
        
        setupTextField()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getMovies(page: 1)
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
        return viewModel.moviesResult.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentView.collectionView.dequeueReusableCell(withReuseIdentifier: MovieCard.identifier, for: indexPath) as! MovieCard
        
        var movie = viewModel.moviesResult[indexPath.row]
        cell.configure(with: movie)
        
        cell.isFavorite = movie.isFavorite ?? false
        
        cell.onFavoriteButtonTapped = { [weak self] in
            guard let self else { return }
            
            cell.isFavorite.toggle()
            
            if let index = MovieDB.shared.favoritedIds.firstIndex(where: { $0 == movie.id }) {
                MovieDB.shared.favoritedIds.remove(at: index)
            } else {
                MovieDB.shared.favoritedIds.append(movie.id)
            }
            
            viewModel.handleFavoriteTapped(with: movie.id)
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.moviesResult[indexPath.row]
        self.viewModel.presentMovieDetails(movie: movie)
    }
}

extension HomeViewController: UITextFieldDelegate {
    private func setupTextField() {
        contentView.textField.delegate = self
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        if let searchText = textField.text, !searchText.isEmpty {
            viewModel.searchFilter(using: searchText)
        } else {
            viewModel.getMovies(page: 1)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func reloadData() {
        contentView.collectionView.reloadData()
    }
}
