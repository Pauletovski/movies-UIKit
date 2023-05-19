//
//  MovieDetailsView.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/05/23.
//

import UIKit
import SwiftUI
import Nuke
import Combine

class MovieDetailsView: UIView {
    
    let pipeline = ImagePipeline()
    
    //MARK: - Properties
    
    var onDismissTapped: (() -> Void)?
        
    func configure(with movie: MovieViewData) {
        movieTitleLabel.text = movie.title
        movieReleaseLabel.text = movie.releaseDate
        movieDescriptionLabel.text = movie.description
        
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.image)")
        let request = ImageRequest(url: url)
        pipeline.loadImage(with: request) { result in
            switch result {
            case .success(let response):
                self.movieImage.image = response.image
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
    }
    
    lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    lazy var movieReleaseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Dismiss", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        button.backgroundColor = .primaryGray
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(
          top: 10,
          left: 20,
          bottom: 10,
          right: 20
        )
        
        return button
    }()
    


    
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
extension MovieDetailsView: ViewCoded {
    func buildViewHierarchy() {
      addSubview(movieImage)
      addSubview(movieTitleLabel)
      addSubview(movieDescriptionLabel)
      addSubview(movieReleaseLabel)
      addSubview(dismissButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieImage.heightAnchor.constraint(equalToConstant: 400),
            movieTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieTitleLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 16),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            movieDescriptionLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 16),
            movieReleaseLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieReleaseLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieReleaseLabel.topAnchor.constraint(equalTo: movieDescriptionLabel.bottomAnchor, constant: 16),
            dismissButton.topAnchor.constraint(equalTo: movieReleaseLabel.bottomAnchor, constant: 16),
            dismissButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func addAdditionalConfiguration() {
        backgroundColor = .primaryYellow
    }
}
