//
//  MovieCard.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 09/04/23.
//

import UIKit
import Nuke

class MovieCard: UICollectionViewCell {
    static let identifier = "MovieCard"
    
    //MARK: - Properties
    
    var onFavoriteButtonTapped: (() -> Void)?
    
    var isFavorite = false {
        didSet {
            let image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            favoriteButton.setImage(image, for: .normal)
        }
    }
    
    let pipeline = ImagePipeline()
    
    func configure(with movie: MovieViewData) {
        movieTitleLabel.text = movie.title
        
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
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.backgroundColor = .primaryGray
        
        return stackView
    }()
    
    lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .primaryYellow
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.tintColor = .primaryYellow
        
        return button
    }()
    
    lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let spacerViewLeading = UIView()
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(movieImage)
        addSubview(stackView)
        stackView.addArrangedSubview(movieTitleLabel)
        stackView.addArrangedSubview(favoriteButton)
        stackView.addArrangedSubview(spacerViewLeading)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            movieImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieImage.topAnchor.constraint(equalTo: topAnchor),
            movieImage.bottomAnchor.constraint(equalTo: stackView.topAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            movieTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            movieTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            movieTitleLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            
            favoriteButton.widthAnchor.constraint(equalToConstant: 20),
            favoriteButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -8)
        ])
    }
    
    //MARK: - Actions
    
    @objc private func favoriteButtonTapped() {
        self.onFavoriteButtonTapped?()
    }
}
