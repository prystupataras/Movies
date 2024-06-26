//
//  DetailVC.swift
//  Movies
//
//  Created by Prystupa Taras on 25.06.2024.
//

import UIKit
import AVKit
import AVFoundation

class DetailVC: UIViewController {
    
    @IBOutlet weak var posterImage:    UIImageView!
    @IBOutlet weak var nameLbl:        UILabel!
    @IBOutlet weak var countryYearLbl: UILabel!
    @IBOutlet weak var genreLbl:       UILabel!
    @IBOutlet weak var ratingLbl:      UILabel!
    @IBOutlet weak var trailerBtn:     UIButton!
    @IBOutlet weak var overviewTV:     UITextView!
    
    private var progressView: DownloadProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchMovie(for: self.id) { movie, error in
            guard let movie = movie else { return }
            self.configure(movie)
        }
    }
    
    private var id: Int!
    private var viewModel: MovieListVM!
    
    private var trailers: [MovieVideo] = []
    
    private let playerViewController = AVPlayerViewController()
    private var player: AVPlayer?
    
    
    func inject(for id: Int, viewModel: MovieListVM) {
        self.id = id
        self.viewModel = viewModel
    }
    
    @IBAction func trailerBtnWasPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "playerVC", sender: trailers.first)
    }
    
    @objc func posterTapped() {
        performSegue(withIdentifier: "posterVC", sender: posterImage.image)
    }
    
    
    private func configure(_ movie: Movie?) {
        guard let movie = movie else { return }
        
        nameLbl.text = movie.titleText
        
        let names = movie.genres?.map { genre -> String in
            return genre.name
        }
        
        countryYearLbl.text = movie.originCountry?.joined(separator: ", ")
        genreLbl.text = names?.joined(separator: ", ")
        ratingLbl.text = String(movie.voteAverage)
        
        overviewTV.text = movie.overview
        
        trailers = movie.youtubeTrailers ?? []
        trailerBtn.isHidden = trailers.isEmpty
        
        progressView = DownloadProgressView(frame: posterImage.bounds)

        if let progressView = progressView {
            posterImage.addSubview(progressView)
        }
        
        ImageDownloader.shared.downloadImage(from: movie.posterURL) { image in
            guard image != nil else { return }
            DispatchQueue.main.async {
                self.progressView?.removeFromSuperview()
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
        
        if let vc = segue.destination as? TrailerVC {
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
            
            vc.video = sender as? MovieVideo
        }
    }
}
