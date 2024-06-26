//
//  ViewController.swift
//  FilmApp
//
//  Created by Taha Chaouch on 26/6/2024.
//

import UIKit

class FilmViewController: UIViewController {
    
    // MARK: - Properties
    
    private let networkManager = NetworkManager.shared
    private var films: [Film] = []
    private var currentPage = 1
    private var isFetching = false 
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FilmCell.self, forCellReuseIdentifier: FilmCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchFilms()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Networking
    
    private func fetchFilms() {
        guard !isFetching else { return } // Prevent multiple fetch requests
        isFetching = true
        
        // Show loader
        activityIndicator.startAnimating()
        
        networkManager.fetchFilms(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            // Hide loader
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
            switch result {
            case .success(let films):
                self.films.append(contentsOf: films)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print("Failed to fetch films: \(error.localizedDescription)")
                // Show error alert
                self.showErrorAlert()
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "An error occurred while fetching films.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.fetchFilms()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource

extension FilmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmCell.reuseIdentifier, for: indexPath) as! FilmCell
        let film = films[indexPath.row]
        cell.configure(with: film)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FilmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilm = films[indexPath.row]
        let detailVC = FilmDetailViewController()
        detailVC.filmId = selectedFilm.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Check if the last cell is being displayed
        if indexPath.row == films.count - 1 {
            currentPage += 1
            fetchFilms()
        }
    }
}

