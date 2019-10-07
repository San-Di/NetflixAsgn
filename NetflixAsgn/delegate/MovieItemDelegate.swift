//
//  MovieItemDelegate.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/4/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import Foundation

protocol MovieItemDelegate {
    func onClickMovieDetail(id: Int?, title: String?)
}
