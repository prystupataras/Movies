//
//  ActivityIndicator.swift
//  Movies
//
//  Created by Prystupa Taras on 26.06.2024.
//

import UIKit

class ActivityIndicator: UIActivityIndicatorView  {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    deinit {
        if self.isAnimating {
            self.stopAnimating()
        }
    }
    
    private func setupViews() {
        self.style = .large
        self.color = .label
    }
}
