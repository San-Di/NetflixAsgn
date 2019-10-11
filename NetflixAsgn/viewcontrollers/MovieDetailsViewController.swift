//
//  MovieDetailsViewController.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/4/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class MovieDetailsViewController: UIViewController {

    var movieId : Int = 0
    
    var similarMovieList: Results<MovieVO>?
    
    let realm = try! Realm()
    
    
    let sessionId = UserDefaults.standard.object(forKey: "token") as? String
    let accountId = UserDefaults.standard.object(forKey: "userId") as? Int
    
    private var movieListNotifierToken : NotificationToken?
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var lblisAdult: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    
    @IBOutlet weak var btnAddtoWatchList: UIButton!
    
    @IBOutlet weak var btnAddtoRateList: UIButton!
    
    @IBOutlet weak var similarMoviesCollectionView: UICollectionView!
    
    @IBAction func btnDismissDetailView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddtoList(_ sender: Any) {
        addToWatchList(movieId: movieId)
    }
    
    @IBAction func btnRate(_ sender: Any) {
        print("Click rate")
        addToRateList(movieId: movieId)
    }
    
    @IBAction func btnPlayTrailer(_ sender: Any) {
        fetchVideoKey(movieId: movieId)
    }
    
    fileprivate func realmNotiObserver(){
        similarMovieList = realm.objects(MovieVO.self).filter("category = '\(String(movieId))'")
        
        movieListNotifierToken = similarMovieList?.observe{ [weak self] (changes : RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.similarMoviesCollectionView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                self?.similarMoviesCollectionView.performBatchUpdates({
                    self?.similarMoviesCollectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    self?.similarMoviesCollectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0)}))
                    self?.similarMoviesCollectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0)}))
                }, completion: nil)
                
                break
            case .error(let error):
                fatalError("\(error)")
                break;
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieDetails(movieId: movieId)
        fetchSimilarMovies(movieId: movieId)
        similarMoviesCollectionView.delegate = self
        similarMoviesCollectionView.dataSource = self
        
        similarMoviesCollectionView.register(UINib(nibName: String(describing: MovieInnerCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieInnerCollectionViewCell.self))
        
        similarMoviesCollectionView.register(UINib(nibName: String(describing: TitleSupplementaryCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: TitleSupplementaryCollectionReusableView.self))
        
        
        let layout = similarMoviesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (similarMoviesCollectionView.bounds.width - 28) / 3, height: 160)
                layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 4
        
        realmNotiObserver()
    }
    
    fileprivate func addToWatchList(movieId: Int) {
        
        MovieModel.shared.addToWatchList(movieId: movieId, accountId: accountId ?? 0, sessionId: sessionId ?? "") { (status) in
            print("Added to watchlist")
            self.btnAddtoWatchList.setImage(#imageLiteral(resourceName: "icons8-plus_math-1"), for: .normal)
        }
    }
    
    fileprivate func addToRateList(movieId: Int) {
        MovieModel.shared.postRateMovie(movieId: movieId, sessionId: sessionId ?? "") { (status) in
            print("HERE!!!!!!!")
            DispatchQueue.main.async {
//                btnRate(<#T##sender: Any##Any#>)
                print("STATUS \(status)")
                self.btnAddtoRateList.setImage(#imageLiteral(resourceName: "icons8-facebook_like-1"), for: .normal)
            }
        }
        
    }
    fileprivate func fetchMovieDetails(movieId : Int) {
        
        MovieModel.shared.fetchMovieDetails(movieId: movieId) { [weak self] movieDetails in
            
            DispatchQueue.main.async {
                self?.bindData(data: MovieInfoResponse.convertToMovieVO(data: movieDetails, realm: self!.realm))
            }
        }
        
    }
    
    fileprivate func fetchSimilarMovies(movieId: Int){
        let moviesList = realm.objects(MovieVO.self).filter("category = '\(String(movieId))'")
        
        if moviesList.isEmpty{
            MovieModel.shared.fetchSimilarMovies(movieId: movieId) { [weak self] movies in
                DispatchQueue.main.async { [weak self] in
                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(category: String(movieId), data: movie, realm: self!.realm)
                        print(" MOVIE !! \(movie)")
                    }
                    
                }
            }
        }
        else {
            self.similarMovieList = moviesList
            similarMoviesCollectionView.reloadData()
        }
    }
    
    fileprivate func fetchVideoKey(movieId: Int){
        MovieModel.shared.fetchVideoKey(movieId: movieId, completion: { [weak self] videos in
            DispatchQueue.main.async { [weak self] in
                print("Get video \(videos)")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let vc = storyboard.instantiateViewController(withIdentifier: String(describing: PlayTrailerViewController.self)) as! PlayTrailerViewController
                vc.videoKey = videos.first?.key
                self?.present(vc, animated: true)
                }
            })
    }
    
    fileprivate func bindData(data : MovieVO) {
        
        imgPoster.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), placeholderImage: #imageLiteral(resourceName: "placeholder"), options:  SDWebImageOptions.progressiveLoad, completed: nil)
        
        imgBackground.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), placeholderImage: #imageLiteral(resourceName: "placeholder"), options:  SDWebImageOptions.progressiveLoad, completed: nil)
        
        if data.adult {
            lblisAdult.text = "18+"
        }else{
            lblisAdult.text = "18-"
        }
        
        lblOverview.text = data.overview
        lblDuration.text = convertTime(minute: data.runtime)
        let releaseYear = data.release_date?.split(separator: "-")
        lblReleaseDate.text = String(releaseYear?.first ?? "")
        
    }
    
    fileprivate func convertTime(minute: Int) -> String{
        let hour: Int = minute/60
        let min: Int = minute % 60
        
        return "\(hour)hr \(min)min"
    }
}

extension MovieDetailsViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: TitleSupplementaryCollectionReusableView.self), for: indexPath) as! TitleSupplementaryCollectionReusableView
        
        sectionHeader.lblSectionTitle.text = "MORE LIKE THIS"
        
        return sectionHeader
    }
}

extension MovieDetailsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovieList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieInnerCollectionViewCell.self), for: indexPath) as! MovieInnerCollectionViewCell
        cell.data = similarMovieList?[indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
