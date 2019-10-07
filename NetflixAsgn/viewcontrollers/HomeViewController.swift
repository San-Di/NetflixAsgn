//
//  HomeViewController.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/3/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var homeOuterCollectionView: UICollectionView!
    
    let realm = try! Realm()
    
    var movieListTrending : Results<MovieVO>?
    var movieListNowPlaying: Results<MovieVO>?
    var movieListUpcoming: Results<MovieVO>?
    var movieListTopRated: Results<MovieVO>?

    override func viewDidLoad() {
        super.viewDidLoad()
        URLCache.shared.removeAllCachedResponses()
        homeOuterCollectionView.delegate = self
        homeOuterCollectionView.dataSource = self
        
        homeOuterCollectionView.register(UINib(nibName: String(describing: MovieListCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieListCollectionViewCell.self))
        
        homeOuterCollectionView.register(UINib(nibName: String(describing: TitleSupplementaryCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: TitleSupplementaryCollectionReusableView.self))
        
        let collectionViewFlowlayout = homeOuterCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        collectionViewFlowlayout.itemSize = CGSize(width: (self.view.frame.width), height: 180)

        fetchTrendingMovies()
        fetchNowPlaying()
        fetchUpcomingMovies()
        fetchTopRatedMovies()
        
//        realmNotiObserver()
    }

    fileprivate func fetchTrendingMovies() {
        let moviesList = realm.objects(MovieVO.self).filter("category = 'Trending'")
        
        if moviesList.isEmpty{
            MovieModel.shared.fetchTrendingMovies { (movies) in
                movies.forEach({ [weak self] movie in
                    DispatchQueue.main.async {
                        //                        MovieListResponse.sav
                        MovieInfoResponse.saveMovie(category: Categories.Trending.rawValue, data: movie, realm: self!.realm)
                        
                    }
                })
            }
        }
        else {
            self.movieListTrending = moviesList
        }
        homeOuterCollectionView.reloadData()
    }
    
    fileprivate func fetchTopRatedMovies() {
        
        let moviesList = realm.objects(MovieVO.self).filter("category = 'Toprated'")
        
        if moviesList.isEmpty{
            MovieModel.shared.fetchTopRatedMovies { [weak self] movies in
                DispatchQueue.main.async { [weak self] in
                    
                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(category: Categories.Toprated.rawValue, data: movie, realm: self!.realm)
                    }
                    
                }
                
            }
        }else {
            self.movieListTopRated = moviesList
        }
        
        homeOuterCollectionView.reloadData()
    }
    
    fileprivate func fetchNowPlaying() {
        
        let moviesList = realm.objects(MovieVO.self).filter("category = 'NowPlaying'")
        
        if moviesList.isEmpty{
            MovieModel.shared.fetchNowPlayingMovies { [weak self] movies in
                DispatchQueue.main.async { [weak self] in
                    
                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(category: Categories.NowPlaying.rawValue, data: movie, realm: self!.realm)
                    }
                    
                }
                
            }
        }else {
            self.movieListNowPlaying = moviesList
           
        }
         homeOuterCollectionView.reloadData()
    }
    
    fileprivate func fetchUpcomingMovies() {
        let moviesList = realm.objects(MovieVO.self).filter("category = 'Upcoming'")
        
        if moviesList.isEmpty{
            MovieModel.shared.fetchUpcomingMovies{ [weak self] movies in
                DispatchQueue.main.async { [weak self] in

                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(category: Categories.Upcoming.rawValue, data: movie, realm: self!.realm)
                    }

                }

            }
        }else {
            self.movieListUpcoming = moviesList
        }
         homeOuterCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Movie List"
    }
    
 }

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: TitleSupplementaryCollectionReusableView.self), for: indexPath) as! TitleSupplementaryCollectionReusableView
        
        switch indexPath.section {
        case 0:
            cell.lblSectionTitle.text = "Featured Movies"
        case 1:
            cell.lblSectionTitle.text = "Upcoming Movies"
        case 2:
            cell.lblSectionTitle.text = "Recommended Movies"
        case 3:
            cell.lblSectionTitle.text = "Library"
        default:
            cell.lblSectionTitle.text = "Section Headers"
        }
        return cell
    }
   
}

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieListCollectionViewCell.self), for: indexPath) as! MovieListCollectionViewCell
        item.delegate = self
        switch indexPath.section {
        case 0:
            item.movieList = movieListTrending
            break
        case 1:
            item.movieList = movieListUpcoming
            break
//        case 2:
//            item.sectionCategory = Categories.Upcoming.rawValue
//            break
//        case 3:
//            item.sectionCategory = Categories.Toprated.rawValue
//            break
        default:
            item.movieList = movieListTopRated
            
        }
        return item
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
}
extension HomeViewController: MovieItemDelegate {
    func onClickMovieDetail(id: Int?, title: String?) {
        print("ID&&&& ====> \(id)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: MovieDetailsViewController.self)) as! MovieDetailsViewController

        vc.movieId = id ?? 0
        self.present(vc, animated: true)

    }
}
