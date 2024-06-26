//
//  AddFilterViewController.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 18/05/23.
//

import UIKit

public class AddFilterViewController: UIViewController {
    
    //MARK: - Properties
    private var viewModel: AddFiltersViewModel
    lazy var contentView: AddFiltersView = {
        AddFiltersView()
    }()
    
    //MARK: - Init
    init(viewModel: AddFiltersViewModel) {
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
        
    }
    
    //MARK: - Methods
    private func setupBindings() {
    }
    
    private func setup() {
        setupBindings()
        setupTableView()
    }
    
    func setupTableView(){
        contentView.genreList.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        contentView.genreList.delegate = self
        contentView.genreList.dataSource = self
    }
}


extension AddFilterViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.genresList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell {
            cell.setupCell(text: viewModel.genresList[indexPath.row].name)
            
            return cell
        }
        fatalError("could not dequeueReusableCell")
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genre = viewModel.genresList[indexPath.row]
        self.viewModel.selectedGenre(genre)
        self.contentView.dismissScreen()
    }
}

extension AddFilterViewController: AddFiltersViewModelDelegate {
    func reloadData() {
        self.contentView.genreList.reloadData()
    }
}
