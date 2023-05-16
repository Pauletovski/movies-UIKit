//
//  MovieDetailsView.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 16/05/23.
//

import UIKit
import Nuke

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
        
        // Adjust content hugging priority
        movieDescriptionLabel.setContentHuggingPriority(.required, for: .vertical)
        movieReleaseLabel.setContentHuggingPriority(.required, for: .vertical)
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
        label.clipsToBounds = true
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
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
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
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
        scrollView.addSubview(movieDescriptionLabel)
        addSubview(scrollView)
        addSubview(movieReleaseLabel)
        addSubview(dismissButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieImage.heightAnchor.constraint(equalToConstant: 500),
            
            movieTitleLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 16),
            movieTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: movieReleaseLabel.topAnchor, constant: -16),
            
            movieDescriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            movieDescriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            movieDescriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            movieReleaseLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieReleaseLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieReleaseLabel.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -16),
            
            dismissButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            dismissButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width - 16, height: 2000)
    }


    
    func addAdditionalConfiguration() {
        backgroundColor = .primaryYellow
    }
}
