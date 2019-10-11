//
//  MovieModel.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/3/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import Foundation
import Alamofire

class MovieModel{
    
    static let shared = MovieModel()
    
    private init() {}
    
    func fetchMoviesByName(movieName : String, completion : @escaping ([MovieInfoResponse]) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_SEACRH_MOVIES)?api_key=\(API.KEY)&query=\(movieName.replacingOccurrences(of: " ", with: "%20") )")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.results)
            }
            }.resume()
    }
    
    func fetchMovieDetails(movieId : Int, completion: @escaping (MovieInfoResponse) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_MOVIE_DETAILS)/\(movieId)?api_key=\(API.KEY)")!
        print("\(Routes.ROUTE_MOVIE_DETAILS)/\(movieId)?api_key=\(API.KEY)")
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieInfoResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            }
        }.resume()
    }

    func fetchTopRatedMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_MOVIES_TOP_RATED)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.results)
                
            } else {
                completion([MovieInfoResponse]())
            }
        }.resume()
        
    }

    func fetchTrendingMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_MOVIES_TRENDING)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.results)
                
            } else {
                completion([MovieInfoResponse]())
            }
        }.resume()
        
    }
    
    func fetchNowPlayingMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_MOVIES_NOW_PLAYING)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //                print(data.results.count)
                completion(data.results)
                
            } else {
                completion([MovieInfoResponse]())
            }
        }.resume()
        
    }
    
    func fetchUpcomingMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_MOVIES_UPCOMING)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //                print(data.results.count)
                completion(data.results)
                
            } else {
                completion([MovieInfoResponse]())
            }
        }.resume()
        
    }
    
    func fetchSimilarMovies(pageId : Int = 1, movieId: Int, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(API.BASE_URL)/movie/\(movieId)/similar?api_key=\(API.KEY)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //                print(data.results.count)
                completion(data.results)
                
            } else {
                completion([MovieInfoResponse]())
            }
        }.resume()
        
    }
    func fetchVideoKey(movieId: Int, completion : @escaping (([MovieVideoResponse]) -> Void) )  {
        let route = URL(string: "\(API.BASE_URL)/movie/\(movieId)/videos?api_key=\(API.KEY)")!
        print("Video endpoint \(API.BASE_URL)/movie/\(movieId)/videos?api_key=\(API.KEY)")
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : VideoListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            
            print("video response\(response)")
            if let data = response {
                completion(data.results)
                
            } else {
                completion([MovieVideoResponse]())
            }
        }.resume()
        
    }
    
    func addToWatchList(movieId: Int, accountId: Int, sessionId: String, completion : @escaping ((String) -> Void)) {
        let parameters: [String: Any] = [
            "media_type": "movie",
            "media_id": movieId,
            "watchlist": true
        ]
        
        Alamofire.request(URL(string: Routes.ROUTE_ADD_WATCH_LIST + "/\(accountId)/watchlist?api_key=\(API.KEY)&session_id=\(sessionId)") ?? "", method: .post, parameters: parameters, headers: [:]).responseData { (response) in
            guard let data = response.result.value else { return }
            
            switch response.result {
            case .success:
                
                do {
                    let decoder = JSONDecoder()
                    
                    let baseResponse = try decoder.decode(AddWatchListResponse.self, from: data)
                    
                    if(baseResponse.status_code == 1 || baseResponse.status_code == 12) {

                        completion(baseResponse.status_message)
                    }
                }catch let jsonErr {
                    print("Failure json Err!!! \(jsonErr.localizedDescription)")
                }
                break
                
            case .failure(let err):
                print("Err => \(err.localizedDescription)")
                break
            }
        }
        
    }
    
    
    func getRatedMovies(sessionId: String, userId: Int, completion : @escaping (String) -> Void){
        let route = URL(string: "\(Routes.ROUTE_RATED_MOVIES)/\(userId)/rated/movies?api_key=\(API.KEY)&session_id=\(sessionId)")!
        
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion("Rated List \(data.total_results)")
            }
            }.resume()
    }
    
    func getWatchedListMovies(sessionId: String, userId: Int, completion : @escaping ([MovieInfoResponse]) -> Void){
        let route = URL(string: "\(Routes.ROUTE_RATED_MOVIES)/\(userId)/watchlist/movies?api_key=\(API.KEY)&session_id=\(sessionId)")!
        
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.results)
            }
        }.resume()
    }

    func postRateMovie(movieId: Int, sessionId: String, completion : @escaping (String) -> Void) {
        let headers = [
            "Content-Type": "application/json;charset=utf-8"
        ]
        let parameters = ["value": 8.5]
        
        Alamofire.request(URL(string: Routes.ROUTE_ADD_RATE_LIST + "/\(movieId)/rating?api_key=\(API.KEY)&session_id=\(sessionId)") ?? "", method: .post, parameters: parameters, headers: headers).responseData { (response) in
            
            print("here's the route \(Routes.ROUTE_ADD_RATE_LIST + "/\(movieId)/rating?api_key=\(API.KEY)&session_id=\(sessionId)"))")
            guard let data = response.result.value else { return }
            
            switch response.result {
            case .success:
                
                do {
                    let decoder = JSONDecoder()
                    
                    let baseResponse = try decoder.decode(AddWatchListResponse.self, from: data)
                    
                    if(baseResponse.status_code == 1 || baseResponse.status_code == 12) {
                        print("Success**** \(baseResponse.status_message)")
                        completion(baseResponse.status_message)
                    }
                }catch let jsonErr {
                    print("Failure json Err!!! \(jsonErr.localizedDescription)")
                }
                break
                
            case .failure(let err):
                print("Err => \(err.localizedDescription)")
                break
            }
        }
    }
    
    func responseHandler<T : Decodable>(data : Data?, urlResponse : URLResponse?, error : Error?) -> T? {
        let TAG = String(describing: T.self)
        if error != nil {
            print("\(TAG): failed to fetch data : \(error!.localizedDescription)")
            return nil
        }
        
        let response = urlResponse as! HTTPURLResponse
        
        if response.statusCode == 200 {
            guard let data = data else {
                print("\(TAG): empty data")
                return nil
            }
            
            if let result = try? JSONDecoder().decode(T.self, from: data) {
                return result
            } else {
                print("\(TAG): failed to parse data")
                return nil
            }
        } else {
            print("\(TAG): Network Error - Code: \(response.statusCode)")
            return nil
        }
    }
}
