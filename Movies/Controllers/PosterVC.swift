//
//  PosterVC.swift
//  Movies
//
//  Created by Prystupa Taras on 25.06.2024.
//

import UIKit

class PosterVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView:  UIScrollView!
    @IBOutlet weak var posterImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterImage.image = image
        
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
    
    var image: UIImage!

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return posterImage
    }
}
