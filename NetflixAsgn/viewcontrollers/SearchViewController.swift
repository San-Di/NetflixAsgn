//
//  SearchViewController.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/3/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {

    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let ui = UIActivityIndicatorView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.stopAnimating()
        ui.isHidden = true
        ui.style = UIActivityIndicatorView.Style.whiteLarge
        return ui
    }()
    
    private var searchedResult = [MovieInfoResponse]()
    let realm  = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "Search Movies"
        
        searchController.searchBar.becomeFirstResponder()
    }
    
    fileprivate func initView() {
        // Setup the Search Controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Eg: One upon a time in Hollywood"
        
        navigationItem.searchController = searchController
        navigationItem.largeTitleDisplayMode = .always
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = .black
        
        
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        
        searchCollectionView.register(UINib(nibName: String(describing: MovieInnerCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieInnerCollectionViewCell.self))
//        searchCollectionView.backgroundColor = Theme.background
        
        self.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        
    }
    
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = searchedResult[indexPath.row]
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieInnerCollectionViewCell.self), for: indexPath) as? MovieInnerCollectionViewCell else {
//            return UICollectionViewCell()
//        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieInnerCollectionViewCell.self), for: indexPath) as? MovieInnerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movieVO = MovieInfoResponse.convertToMovieVO(data: movie, realm: realm)
        
        cell.data = movieVO
        
        
        return cell
    }
}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        let searchedMovie = searchBar.text ?? ""
        MovieModel.shared.fetchMoviesByName(movieName: searchedMovie) { [weak self] results in
            self?.searchedResult = results
            print("SearchResult \(results)")

            DispatchQueue.main.async {

                results.forEach({ [weak self] (movieInfo) in
                    MovieInfoResponse.saveMovie(category: Categories.Search.rawValue, data: movieInfo, realm: self!.realm)
                })

//                if results.isEmpty {
//                    self?.labelMovieNotFound.text = "No movie found with name \"\(searchedMovie)\" "
//                    return
//                }
//
//                self?.labelMovieNotFound.text = ""
                self?.searchCollectionView.reloadData()

                self?.activityIndicator.stopAnimating()
            }
        }
    }
}

extension SearchViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}


extension SearchViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}


