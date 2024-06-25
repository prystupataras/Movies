//
//  DetailVC.swift
//  Movies
//
//  Created by Prystupa Taras on 25.06.2024.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var posterImage:    UIImageView!
    @IBOutlet weak var nameLbl:        UILabel!
    @IBOutlet weak var countryYearLbl: UILabel!
    @IBOutlet weak var genreLbl:       UILabel!
    @IBOutlet weak var ratingLbl:      UILabel!
    @IBOutlet weak var trailerBtn:     UIButton!
    @IBOutlet weak var overviewTV:     UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    private var viewModel: MovieListVM!
    
    var movie: Movie? {
        didSet {
            viewModel?.fetchDetail(for: movie)
        }
    }
    
    func inject(viewModel: MovieListVM) {
        self.viewModel = viewModel
    }
    
    @IBAction func trailerBtnWasPressed(_ sender: UIButton) {
        //show trailer if need
    }
    
    @objc func posterTapped() {
        performSegue(withIdentifier: "posterVC", sender: posterImage.image)
    }
    
    
    private func configure() {
        guard let movie = self.movie else { return }
        
        nameLbl.text = movie.titleText
        
        let names = movie.genres?.map { genre -> String in
            return genre.name
        }
        
        countryYearLbl.text = movie.originCountry?.joined(separator: ", ")
        genreLbl.text = names?.joined(separator: ", ")
        ratingLbl.text = String(movie.voteAverage)
        
        overviewTV.text = movie.overview
        
        trailerBtn.isHidden = !movie.hasTrailer
        
        ImageDownloader.shared.downloadImage(from: movie.posterURL) { image in
            guard image != nil else { return }
            DispatchQueue.main.async {
                self.posterImage.image = image
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(posterTapped))
        self.posterImage.addGestureRecognizer(tapGesture)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PosterVC {
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
            
            vc.image = sender as? UIImage
        }
    }
}
