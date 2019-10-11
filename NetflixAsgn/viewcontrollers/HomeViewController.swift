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
    
    var moviesList = [Categories: Results<MovieVO>]()
    
    
    private var movieListNotifierToken : NotificationToken?
    
    var categoriesList : [Categories] {
        return Categories.allCases
        
    }

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
        let moviesList = realm.objects(MovieVO.self).filter("category = '\(Categories.Trending.rawValue)'")
        
        if moviesList.isEmpty{
            MovieModel.shared.fetchTrendingMovies { (movies) in
                movies.forEach({ [weak self] movie in
                    DispatchQueue.main.async {
                        //                        MovieListResponse.sav
                        MovieInfoResponse.saveMovie(category: Categories.Trending.rawValue, data: movie, realm: self!.realm)
//                        let indexPath = [IndexPath(row: 0, section: 0)]
//                        self?.homeOuterCollectionView.reloadItems(at: indexPath)
                    }
                })
            }
        }
        else {
            self.moviesList[Categories.Trending] = moviesList
//            let indexPath = [IndexPath(row: 0, section: 0)]
//            homeOuterCollectionView.reloadItems(at: indexPath)
        }
    }
    
    fileprivate func fetchTopRatedMovies() {
        
        let moviesList = realm.objects(MovieVO.self).filter("category = '\(Categories.Toprated.rawValue)'")
        
        if moviesList.isEmpty{
            MovieModel.shared.fetchTopRatedMovies { [weak self] movies in
                DispatchQueue.main.async { [weak self] in
                    
                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(category: Categories.Toprated.rawValue, data: movie, realm: self!.realm)
//                        let indexPath = [IndexPath(row: 0, section: 3)]
//                        self?.homeOuterCollectionView.reloadItems(at: indexPath)
                    }
                    
                }
                
            }
        }else {
            self.moviesList[Categories.Toprated] = moviesList
//            let indexPath = [IndexPath(row: 0, section: 3)]
//            homeOuterCollectionView.reloadItems(at: indexPath)
        }
        
    }
    
    fileprivate func fetchNowPlaying() {
        
        let moviesList = realm.objects(MovieVO.self).filter("category = '\(Categories.NowPlaying.rawValue)'")
        
        if moviesList.isEmpty{
            MovieModel.shared.fetchNowPlayingMovies { [weak self] movies in
                DispatchQueue.main.async { [weak self] in
                    
                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(category: Categories.NowPlaying.rawValue, data: movie, realm: self!.realm)
//                        let indexPath = [IndexPath(row: 0, section: 1)]
//                        self?.homeOuterCollectionView.reloadItems(at: indexPath)
                    }
                    
                }
                
            }
        }else {
            self.moviesList[Categories.NowPlaying] = moviesList
//            let indexPath = [IndexPath(row: 0, section: 1)]
//            homeOuterCollectionView.reloadItems(at: indexPath)
        }
        
    }
    
    fileprivate func fetchUpcomingMovies() {
        let moviesList = realm.objects(MovieVO.self).filter("category = '\(Categories.Upcoming.rawValue)'")
        
        if moviesList.isEmpty{
            MovieModel.shared.fetchUpcomingMovies{ [weak self] movies in
                DispatchQueue.main.async { [weak self] in

                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(category: Categories.Upcoming.rawValue, data: movie, realm: self!.realm)
//                        let indexPath = [IndexPath(row: 0, section: 2)]
//                        self?.homeOuterCollectionView.reloadItems(at: indexPath)
                    }

                }

            }
        }else {
            self.moviesList[Categories.Upcoming] = moviesList
//            let indexPath = [IndexPath(row: 0, section: 2)]
//            homeOuterCollectionView.reloadItems(at: indexPath)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Movie List"
    }
    
    fileprivate func realmNotiObserver(){
        moviesList[Categories.NowPlaying] = realm.objects(MovieVO.self)
        movieListNotifierToken = moviesList[Categories.NowPlaying]?.observe{ [weak self] (changes : RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.homeOuterCollectionView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                self?.homeOuterCollectionView.performBatchUpdates({
                    self?.homeOuterCollectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    self?.homeOuterCollectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0)}))
                    self?.homeOuterCollectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0)}))
                }, completion: nil)
                
                break
            case .error(let error):
                fatalError("\(error)")
                break;
            }
        }
    }
    
    
    deinit {
        movieListNotifierToken?.invalidate()
    }
    
 }

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: TitleSupplementaryCollectionReusableView.self), for: indexPath) as! TitleSupplementaryCollectionReusableView
        
        cell.lblSectionTitle.text = categoriesList[indexPath.section].rawValue
        return cell
    }
   
}

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionKey = categoriesList[section]
        if moviesList[sectionKey]?.count ?? 0 < 1 {
            return 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieListCollectionViewCell.self), for: indexPath) as! MovieListCollectionViewCell
        item.delegate = self
        let sectionKey = categoriesList[indexPath.section]
        print("Section key \(sectionKey)")
        item.movieList = moviesList[sectionKey]
        
        return item
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("NUMber of sections \(moviesList.count)")
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
