//
//  FilmCell.swift
//  FilmApp
//
//  Created by Taha Chaouch on 26/6/2024.
//

import Foundation
import UIKit

class FilmCell: UITableViewCell {

  static let reuseIdentifier = "FilmCell"

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    label.numberOfLines = 0
    return label
  }()

  private let overviewLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14)
    label.numberOfLines = 3
    label.textColor = .gray
    return label
  }()

  private let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    return imageView
  }()

  private var imageLoadingTask: URLSessionDataTask?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageLoadingTask?.cancel()
    posterImageView.image = nil
  }

  private func setupViews() {
    contentView.addSubview(posterImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(overviewLabel)

    contentView.layer.cornerRadius = 8
    contentView.layer.masksToBounds = false
    contentView.layer.shadowRadius = 4
    contentView.layer.shadowOpacity = 0.2
    contentView.layer.shadowOffset = CGSize(width: 0, height: 2)

    NSLayoutConstraint.activate([
      posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      posterImageView.widthAnchor.constraint(equalToConstant: 80),
      posterImageView.heightAnchor.constraint(equalToConstant: 120),

      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

      overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      overviewLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
      overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
    ])
  }
    
    func configure(with film: Film) {
        titleLabel.text = film.title
        overviewLabel.text = film.overview
        if let posterPath = film.posterPath {
            loadImage(from: posterPath)
        } else {
            // Handle case where poster path is nil or not provided
            posterImageView.image = UIImage(named: "your_placeholder_image")
        }
    }
    
    private func loadImage(from urlString: String) {
        let baseUrl = "https://image.tmdb.org/t/p/w500/"
        guard let url = URL(string: baseUrl + urlString) else {
            return
        }
        
        // Check if the image is already cached
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.posterImageView.image = cachedImage
            return
        }
        
        // Start a new image loading task
        imageLoadingTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, let data = data, error == nil else { return }
            if let image = UIImage(data: data) {
                // Cache the loaded image
                ImageCache.shared.saveImage(image, forKey: urlString)
                
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }
        }
        
        imageLoadingTask?.resume()
    }
}
