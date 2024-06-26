//
//  MovieListVC.swift
//  Movies
//
//  Created by Prystupa Taras on 24.06.2024.
//

import UIKit

class MovieListVC: UIViewController, MovieListViewModelDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    
    private lazy var viewModel: MovieListVM = {
        let viewModel = MovieListVM()
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        self.fetchBySort(UserDefaults.standard.integer(forKey: "lastSelectedIndex"))
        
        
        tableView.dataSource = self
        tableView.delegate   = self
        
        
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(buttonTapped))
        
        
//        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
//                                            target: self,
//                                            action: #selector(buttonTapped))

        navigationBarItem.rightBarButtonItem = barButtonItem
    }
    
    private func fetchBySort(_ sortId: Int) {
        var sortOption = Domain.popular
        switch sortId {
        case 0:
            sortOption = Domain.popular
        case 1:
            sortOption = Domain.topRated
        case 2:
            sortOption = Domain.nowPlaying
        case 3:
            sortOption = Domain.upcoming
        default:
            sortOption = Domain.popular
        }
        
        
        viewModel.fetchMoviesBySort(sortDomain: sortOption) { [weak self] movies, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching movies:", error)
                return
            }
            
            self.tableView.reloadData()
        }
    }
    
    @objc func buttonTapped() {
        let actionSheet = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
        
        let options = ["Popular",
                       "Top Rated",
                       "Now Playing",
                       "Upcoming"]
        
        let defaults = UserDefaults.standard
        var selectedIndex = defaults.integer(forKey: "lastSelectedIndex")
        
        selectedIndex = min(selectedIndex, options.count - 1) // Ensure index is valid
        
        for (index, option) in options.enumerated() {
            let action = UIAlertAction(title: option, style: .default) { action in
                selectedIndex = index
                defaults.set(selectedIndex, forKey: "lastSelectedIndex")
                // Update UI or perform action based on selected option
                self.viewModel.cleanMovies()
                self.tableView.reloadData()
                self.fetchBySort(selectedIndex)
            }
            
            if index == selectedIndex {
                action.setValue(true,  forKey: "checked")
            } else {
                action.setValue(false, forKey: "checked")
            }
            
            actionSheet.addAction(action)
        }
        
        let cencel = UIAlertAction(title: "cancel", style: .cancel)
        actionSheet.addAction(cencel)
        
        present(actionSheet, animated: true)
    }
    
    func movieUpdated(_ row: Int) {
        tableView.beginUpdates()
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}

extension MovieListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        cell.configure(with: viewModel.movie(at: indexPath.row))
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height - 100 && !viewModel.isFetching() {
            self.fetchBySort(UserDefaults.standard.integer(forKey: "lastSelectedIndex"))
        }
    }
    
    func tableView(_ tableView: UITableView, performPrimaryActionForRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: viewModel.movie(at: indexPath.row))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailVC {
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
            
            vc.inject(for: (sender as! Movie).id, viewModel: self.viewModel)
        }
    }
}

