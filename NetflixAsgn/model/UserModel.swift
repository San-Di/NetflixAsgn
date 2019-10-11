//
//  UserModel.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/9/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import Foundation
import Alamofire

class UserModel {
    
    static let shared = UserModel()
    
    private init() {}
    
    
    
    func getRequestToken(completion : @escaping (String) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_REQUEST_TOKEN)")!
        print("getREquesttoken \(Routes.ROUTE_REQUEST_TOKEN)")
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : LoginResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.request_token)
            }
        }.resume()
    }
    
    
    func requestLogin(email: String, password: String, requestToken: String, completion : @escaping (String) -> Void) {
        let parameters = ["username": email, "password": password, "request_token": requestToken]
        Alamofire.request(URL(string: Routes.ROUTE_SESSION_WITH_LOGIN) ?? "", method: .post, parameters: parameters, headers: [:]).responseData { (response) in
            print("Hered data!!! \(Routes.ROUTE_SESSION_WITH_LOGIN) \(parameters) \(response.result)")
            guard let data = response.result.value else { return }
            
            
            switch response.result {
            case .success:
                
                do {
                    let decoder = JSONDecoder()
                    let baseResponse = try decoder.decode(LoginResponse.self, from: data)
                    
                    if(baseResponse.success) {
//                        let json = JSON(response.result.value!) // got the whole json respone from network include => (code, message, data)
//                        let data = json["data"] // now this time ( we index data from => ["data"]
                        completion(baseResponse.request_token)
                    }else {
//                        failure(baseResponse.error?.message ?? "")
                    }
                }catch let jsonErr {
                    print("Failure json Err!!! \(jsonErr.localizedDescription)")
//                    failure(jsonErr.localizedDescription)
                }
                break
                
            case .failure(let err):
                print("Err => \(err.localizedDescription)")
//                failure(err.localizedDescription)
                break
            }
        }
    }
    
    
    func requestCreateSession(requestToken: String, completion : @escaping (String) -> Void) {
        let parameters = ["request_token": requestToken]
        Alamofire.request(URL(string: Routes.ROUTE_CREATE_SESSION) ?? "", method: .post, parameters: parameters, headers: [:]).responseData { (response) in
            guard let data = response.result.value else { return }
            
            switch response.result {
            case .success:
                
                do {
                    let decoder = JSONDecoder()
                    
                    let baseResponse = try decoder.decode(SessionResponse.self, from: data)
                    
                    if(baseResponse.success) {
                        //                        let json = JSON(response.result.value!) // got the whole json respone from network include => (code, message, data)
                        //                        let data = json["data"] // now this time ( we index data from => ["data"]
                        completion(baseResponse.session_id)
                    }else {
                        //                        failure(baseResponse.error?.message ?? "")
                    }
                }catch let jsonErr {
                    print("Failure json Err!!! \(jsonErr.localizedDescription)")
                    //                    failure(jsonErr.localizedDescription)
                }
                break
                
            case .failure(let err):
                print("Err => \(err.localizedDescription)")
                //                failure(err.localizedDescription)
                break
            }
        }
    }
    
    func getAccountDetail(sessionId: String, completion : @escaping (UserAccDetailResponse) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_ACC_DETAIL)&session_id=\(sessionId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : UserAccDetailResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                print("user \(data)")
                completion(data)
            }
        }.resume()
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
