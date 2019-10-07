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
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var imgBackground: UIImageView!
    
    @IBOutlet weak var lblisAdult: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    
    @IBOutlet weak var similarMoviesCollectionView: UICollectionView!
    
    @IBOutlet weak var btnAddtoList: UIButton!
    
    @IBOutlet weak var btnRate: UIButton!
    
    @IBAction func btnPlayTrailer(_ sender: Any) {
        fetchVideoKey(movieId: movieId)
//        let youtubeId = "SxTYjptEzZs"
//        var youtubeUrl = NSURL(string:"youtube://\(youtubeId)")!
//        if UIApplication.sharedApplication().canOpenURL(url){
//            UIApplication.sharedApplication().openURL(url)
//        } else{
//            youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
//            UIApplication.sharedApplication().openURL(url)
//        }
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
    }
    
    @objc private func onClickBookmark(_ sender : UIBarButtonItem) {
        ///bookmarked
//        if sender.image == #imageLiteral(resourceName: "icons8-bookmark_ribbon_filled_red") {
//            BookmarkVO.deleteMovieBookmark(movieId: movieId, realm: realm)
//            sender.image = #imageLiteral(resourceName: "icons8-bookmark_ribbon_not_fillled")
//            sender.tintColor = UIColor.white
//        } else { ///not yet bookmarked
//            BookmarkVO.saveMovieBookmark(movieId: movieId, realm: realm)
//            sender.image = #imageLiteral(resourceName: "icons8-bookmark_ribbon_filled_red")
//            sender.tintColor = UIColor.red
//        }
    }
    
    fileprivate func fetchMovieDetails(movieId : Int) {
        
        MovieModel.shared.fetchMovieDetails(movieId: movieId) { [weak self] movieDetails in
            
            DispatchQueue.main.async {
                self?.bindData(data: MovieInfoResponse.convertToMovieVO(data: movieDetails, realm: self!.realm))
            }
        }
        
    }
    
    fileprivate func fetchSimilarMovies(movieId: Int){
        let moviesList = realm.objects(MovieVO.self).filter("category = 'Similar'")
        
        if moviesList.isEmpty{
            MovieModel.shared.fetchSimilarMovies(movieId: movieId) { [weak self] movies in
                DispatchQueue.main.async { [weak self] in
                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(category: Categories.Similar.rawValue, data: movie, realm: self!.realm)
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
                }
            })
    }
    
    fileprivate func bindData(data : MovieVO) {
        print("Detail \(data)")
        
        imgPoster.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), placeholderImage: #imageLiteral(resourceName: "placeholder"), options:  SDWebImageOptions.progressiveLoad, completed: nil)
        
        imgBackground.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), placeholderImage: #imageLiteral(resourceName: "placeholder"), options:  SDWebImageOptions.progressiveLoad, completed: nil)
        
        if data.adult {
            lblisAdult.text = "18+"
        }else{
            lblisAdult.text = ""
        }
        
        lblOverview.text = data.overview
        lblDuration.text = convertTime(minute: data.runtime)
        
    }
    
    fileprivate func convertTime(minute: Int) -> String{
        let hour: Int = minute/60
        let min: Int = minute % 60
        
        print("Hour \(hour) \(min)")
        
        return "\(hour)hr \(min)"
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
