//
//  MovieCell.swift
//  Movies
//
//  Created by Prystupa Taras on 24.06.2024.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleYearLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        movieImageView.layer.cornerRadius = 8
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowColor = UIColor.white.cgColor
      }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Optional: Update image based on orientation (if needed)
        if UIDevice.current.orientation.isLandscape {
            // Update image or layout for landscape
        } else {
            // Update image or layout for portrait
        }
    }
    
    func configure(with movie: Movie) {
        titleYearLabel.text = movie.titleText + ", " + movie.yearText
        
        let names = movie.genres?.map { genre -> String in
            return genre.name
        }
        
        genresLabel.text = names?.joined(separator: ", ")
        
        ratingLabel.text = String(movie.voteAverage)
        
        ImageDownloader.shared.downloadImage(from: movie.backdropURL) { image in
            DispatchQueue.main.async {
                guard image != nil else {
                    self.movieImageView.image = image
                    return
                }

                self.movieImageView.image = image
            }
        }
    }
}
