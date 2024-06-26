//
//  MovieListVC.swift
//  Movies
//
//  Created by Prystupa Taras on 24.06.2024.
//

import UIKit
import Network

class MovieListVC: UIViewController {
    
    @IBOutlet weak var backgroundStackView: UIStackView!
    @IBOutlet weak var backgroundLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let monitor = NWPathMonitor()
    private var progressView: DownloadProgressView?
    
    private lazy var viewModel: MovieListVM = {
        let viewModel = MovieListVM()
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        progressView = DownloadProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        if let progressView = progressView {
            backgroundStackView.isHidden = false
            backgroundStackView.addSubview(progressView)
        }
        
        self.fetchBySort(UserDefaults.standard.integer(forKey: "lastSelectedIndex"))
        
        
        tableView.dataSource = self
        tableView.delegate   = self
        
        
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(buttonTapped))
        navigationBarItem.rightBarButtonItem = barButtonItem
        
        monitor.start(queue: DispatchQueue.main)
    }
    
}

extension MovieListVC : MovieListViewModelDelegate {
    
    func moviesDidChange(_ viewModel: MovieListVM) {
        self.backgroundStackView.isHidden = !(viewModel.numberOfRowsInSection() == 0)
        
        self.progressView?.removeFromSuperview()
        tableView.reloadData()
    }
    
    func movieUpdated(_ row: Int) {
        tableView.beginUpdates()
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}

private extension MovieListVC {
    
    func fetchBySort(_ sortId: Int) {
        guard let sortOption = SortDomain(rawValue: sortId)?.description else { return }
        
        viewModel.fetchMoviesBySort(sortDomain: sortOption) { error in
            if let error = error {
                self.showAlert(message: "Error fetching movies:, \(error) ")
                return
            }
        }
    }
    
    func showAlert(message: String, buttonTitle: String = "OK", completion: ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: completion)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

@objc extension MovieListVC {
    
    func buttonTapped() {
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
    
    func dismissKeyboardOnInteraction() {
        searchBar.resignFirstResponder()
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
        if searchBar.text?.count == 0 {
            if scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height - 100 && !viewModel.isFetching() {
                self.fetchBySort(UserDefaults.standard.integer(forKey: "lastSelectedIndex"))
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboardOnInteraction()
    }
    
    func tableView(_ tableView: UITableView, performPrimaryActionForRowAt indexPath: IndexPath) {
        dismissKeyboardOnInteraction()
        
        if monitor.currentPath.status != .satisfied {
            self.showAlert(message: .offlineMessage)
            return
        }
        
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

extension MovieListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMovie(query: searchText) { error in
            if let error = error {
                self.showAlert(message: "Error searchin movies:, \(error) ")
                return
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.setSerching(flag: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            viewModel.setSerching(flag: false)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchMovie(query: searchBar.text ?? "") { error in
            if let error = error {
                self.showAlert(message: "Error searchin movies:, \(error) ")
                return
            }
        }
    }
}
