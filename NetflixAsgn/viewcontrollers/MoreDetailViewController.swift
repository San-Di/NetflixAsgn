//
//  MoreDetailViewController.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/9/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit
import RealmSwift

class MoreDetailViewController: UIViewController {

    
    @IBOutlet weak var collectionViewMovieList: UICollectionView!
    
    let realm  = try! Realm()
    var watchListMovies = [MovieInfoResponse]()
    let sessionId = UserDefaults.standard.object(forKey: "token") as? String
    let accountId = UserDefaults.standard.object(forKey: "userId") as? Int
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Movie List"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        URLCache.shared.removeAllCachedResponses()
        getWatchListMovies()
        collectionViewMovieList.delegate = self
        collectionViewMovieList.dataSource = self
        
        collectionViewMovieList.register(UINib(nibName: String(describing: MovieInnerCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieInnerCollectionViewCell.self))
        
        let layout = collectionViewMovieList.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (self.view.frame.width - 20)/3, height: 180)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 5
    }
    
    
    fileprivate func getWatchListMovies(){
        MovieModel.shared.getWatchedListMovies(sessionId: sessionId ?? "", userId: accountId ?? 0, completion: { [weak self] results in
            self?.watchListMovies = results
            print("watch list \(results)")
            
            DispatchQueue.main.async {
                
                results.forEach({ [weak self] (movieInfo) in
                    //MovieInfoResponse.saveMovie(category: Categories.Search.rawValue, data: movieInfo, realm: self!.realm)
                })
                self?.collectionViewMovieList.reloadData()
            }
        })
    }
    
}


extension MoreDetailViewController: UICollectionViewDelegate{
    
}

extension MoreDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return watchListMovies.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieInnerCollectionViewCell.self), for: indexPath) as? MovieInnerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = watchListMovies[indexPath.row]
        let movieVO = MovieInfoResponse.convertToMovieVO(data: movie, realm: realm)
        
        cell.data = movieVO
    
        return cell
    }
    
    
}
