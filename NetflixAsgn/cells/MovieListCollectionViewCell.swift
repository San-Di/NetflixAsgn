//
//  MovieListCollectionViewCell.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/3/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit
import RealmSwift

class MovieListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieInnerCollectionView: UICollectionView!
    
    private var movieListNotifierToken : NotificationToken?
    
    var delegate: MovieItemDelegate?
    var clickDetail: (() -> Void)?
    
    let realm = try! Realm()
    
    var movieList : Results<MovieVO>?
    var movieId: Int = 0
    var movieTitle: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieInnerCollectionView.delegate = self
        
        movieInnerCollectionView.dataSource = self
        
        movieInnerCollectionView.register(UINib(nibName: String(describing: MovieInnerCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieInnerCollectionViewCell.self))
        
        let layout = movieInnerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (movieInnerCollectionView.bounds.width - 20) / 4, height: 180)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        
    }
    
    deinit {
        movieListNotifierToken?.invalidate()
    }
    
}

extension MovieListCollectionViewCell: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count \(movieList?.count)")
        return movieList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieInnerCollectionViewCell.self), for: indexPath) as! MovieInnerCollectionViewCell
        item.data = movieList?[indexPath.row]
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickViewDetail))
//        tapGesture.cancelsTouchesInView = false
//        item.imageViewMoviePoster.isUserInteractionEnabled = true
//        item.imageViewMoviePoster.addGestureRecognizer(tapGesture)
        return item
    }    
    
}

extension MovieListCollectionViewCell: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movieList?[indexPath.row]
        movieId = movie?.id ?? 0
        movieTitle =  movie?.original_title ?? ""
        delegate?.onClickMovieDetail(id: movie?.id, title: movie?.original_title)
        print(" ===== ID ====== \(movie?.original_title)")
    }
//    
//    @objc func onClickViewDetail() {
//
//        delegate?.onClickMovieDetail(id: movieId, title: movieTitle)
//    }

}


