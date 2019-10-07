//
//  MovieInfoResponse.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/3/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import Foundation
import RealmSwift

struct MovieInfoResponse : Codable {
    
    let popularity : Double?
    let vote_count : Int?
    let video : Bool?
    let poster_path : String?
    let id : Int?
    let adult : Bool?
    let backdrop_path : String?
    let original_language : String?
    let original_title : String?
    let genre_ids: [Int]?
    let title : String?
    let vote_average : Double?
    let overview : String?
    let release_date : String?
    let runtime: Int?
    
    //Production Companies
    //TODO: Parse Production Companies
    
    enum CodingKeys:String,CodingKey {
        case popularity
        case vote_count
        case video
        case poster_path
        case id
        case adult
        case backdrop_path
        case original_language
        case original_title
        case genre_ids
        case title
        case vote_average
        case overview
        case release_date
        case runtime
     
    }
    
    static func saveMovie(category: String, data : MovieInfoResponse, realm : Realm) {
        //TODO: Implement Realm Save Movie Logic
        var movieVO = MovieVO()
        
        movieVO.popularity = data.popularity ?? 0
        movieVO.vote_count = data.vote_count ?? 0
        movieVO.video = data.video ?? false
        movieVO.poster_path = data.poster_path ?? ""
        movieVO.id = data.id ?? 0
        movieVO.adult = data.adult ?? false
        movieVO.backdrop_path = data.backdrop_path ?? ""
        movieVO.original_language = data.original_language ?? ""
        movieVO.original_title = data.original_title ?? ""
        //        movieVO.genre_ids = data.genre_ids ?? []
        
//        if let genre_ids = data.genre_ids, !genre_ids.isEmpty{
//            genre_ids.forEach { (id) in
//                if let movieGenreVO = MovieGenreVO.getMovieGenreVOById(realm: realm, genreId: id){
//                    movieVO.genres.append(movieGenreVO)
//                }
//            }
//        }
        movieVO.title = data.title ?? ""
        movieVO.vote_average = data.vote_average ?? 0
        movieVO.overview = data.overview ?? ""
        movieVO.release_date = data.release_date ?? ""
        movieVO.category = category
        movieVO.runtime = data.runtime ?? 0
        do{
            try realm.write {
                realm.add(movieVO, update: .modified)
                //                realm.add(movieVO)
            }
        }catch{
            print("Error: \(error.localizedDescription) cannot save init movie list")
        }
        
    }
    
    static func convertToMovieVO(data : MovieInfoResponse, realm : Realm) -> MovieVO {
        //TODO: Write Convert Logic
        let movieVO = MovieVO()
        movieVO.popularity = data.popularity ?? 0
        movieVO.vote_count = data.vote_count ?? 0
        movieVO.video = data.video ?? false
        movieVO.poster_path = data.poster_path ?? ""
        movieVO.id = data.id ?? 0
        movieVO.adult = data.adult ?? false
        movieVO.backdrop_path = data.backdrop_path ?? ""
        movieVO.original_language = data.original_language ?? ""
        movieVO.original_title = data.original_title ?? ""
        //        movieVO.genre_ids = data.genre_ids ?? []
        
        //        if let genre_ids = data.genre_ids, !genre_ids.isEmpty{
        //            genre_ids.forEach { (id) in
        //                if let movieGenreVO = MovieGenreVO.getMovieGenreVOById(realm: realm, genreId: id){
        //                    movieVO.genres.append(movieGenreVO)
        //                }
        //            }
        //        }
        movieVO.title = data.title ?? ""
        movieVO.vote_average = data.vote_average ?? 0
        movieVO.overview = data.overview ?? ""
        movieVO.release_date = data.release_date ?? ""
//        movieVO.category = category
        
        return movieVO
    }

}
