//
//  ComingSoonViewController.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/3/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit
import RealmSwift

class ComingSoonViewController: UIViewController {

    let realm = try! Realm()
    
    @IBOutlet weak var collectionViewUpcomingMovies: UICollectionView!
    
    private var movieListNotifierToken : NotificationToken?
    
    var movieList: Results<MovieVO>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initComingSoonMovies()
        collectionViewUpcomingMovies.delegate = self
        collectionViewUpcomingMovies.dataSource = self
        
        collectionViewUpcomingMovies.register(UINib(nibName: String(describing: MovieInnerCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieInnerCollectionViewCell.self))
        
        let layout = collectionViewUpcomingMovies.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: (self.view.frame.width - 20)/3, height: 180)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 5
    }
    
    fileprivate func initComingSoonMovies(){
        let moviesList = realm.objects(MovieVO.self).filter("category = '\(Categories.Upcoming.rawValue)'")
        
        if moviesList.isEmpty{
            MovieModel.shared.fetchUpcomingMovies{ [weak self] movies in
                DispatchQueue.main.async { [weak self] in
                    
                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(category: Categories.Upcoming.rawValue, data: movie, realm: self!.realm)
                    }
                    
                }
                
            }
        }else {
            self.movieList = moviesList
            collectionViewUpcomingMovies.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Coming Soon Movies"
    }
}

extension ComingSoonViewController: UICollectionViewDelegate{
    
}

extension ComingSoonViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieInnerCollectionViewCell.self), for: indexPath) as! MovieInnerCollectionViewCell
        
        cell.data = movieList?[indexPath.row]
        return cell
    }
    
    
}
