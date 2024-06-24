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
    @IBOutlet weak var ratingLabel: UILabel! // Or RatingView

    func configure(with movie: Movie) {
        movieImageView.image = UIImage(named: movie.imageName)
        titleYearLabel.text = movie.title + ", " + movie.year
        genresLabel.text = movie.genres.joined(separator: ", ")
        ratingLabel.text = String(movie.rating) // Or update RatingView
    }
}
