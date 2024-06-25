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
        // Create and configure the MovieListViewModel instance with any needed dependencies
        let viewModel = MovieListVM()
        // ... (configure dependencies)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchMovies()
        
        tableView.dataSource = self
        tableView.delegate = self // For cell selection (optional)
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                            target: self,
                                            action: #selector(buttonTapped))

        navigationBarItem.rightBarButtonItem = barButtonItem
    }
    
    func moviesDidChange(_ viewModel: MovieListVM) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func movieUpdated(_ row: Int) {
        tableView.beginUpdates()
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    @objc func buttonTapped() {
        let actionSheet = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
        
        let options = ["Popular today",
                       "Popular this week",
                       "Ratings"]
        
        let defaults = UserDefaults.standard
        var selectedIndex = defaults.integer(forKey: "lastSelectedIndex")
        
        selectedIndex = min(selectedIndex, options.count - 1) // Ensure index is valid
        
        for (index, option) in options.enumerated() {
            let action = UIAlertAction(title: option, style: .default) { action in
                selectedIndex = index
                defaults.set(selectedIndex, forKey: "lastSelectedIndex")
                // Update UI or perform action based on selected option
            }
            
            if index == selectedIndex {
                action.setValue(true,  forKey: "checked")
            } else {
                action.setValue(false, forKey: "checked")
            }
            
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true)
    }
}

extension MovieListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMovies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        cell.configure(with: viewModel.movie(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, performPrimaryActionForRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: viewModel.movie(at: indexPath.row))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailVC {
            let barBtn = UIBarButtonItem()
            barBtn.title = ""
            navigationItem.backBarButtonItem = barBtn
            
            vc.inject(viewModel: self.viewModel)
            vc.movie = sender as? Movie
        }
    }
}

