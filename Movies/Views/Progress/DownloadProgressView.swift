//
//  DownloadProgressView.swift
//  Movies
//
//  Created by Prystupa Taras on 26.06.2024.
//

import UIKit

class DownloadProgressView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = .clear
        
        let activityIndicatorView = ActivityIndicator(frame: frame)
        activityIndicatorView.startAnimating()
        addSubview(activityIndicatorView)

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
