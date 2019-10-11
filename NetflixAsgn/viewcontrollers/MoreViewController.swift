//
//  MoreViewController.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/9/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    let titleList: [String] = ["My List", "Rated List"]
    @IBOutlet weak var tableViewMoreList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewMoreList.dataSource = self
        tableViewMoreList.delegate = self
        tableViewMoreList.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        tableViewMoreList.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "More"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }
}

extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let movieListMoreViewController = self.segue.destination as? MoreDetailViewController {
//            if let indexPath = tableViewMoreList.indexPathForSelectedRow {
//                let genreVO = movieGenres?[indexPath.row]
//                movieListByGenreViewController.movieGenreVO = genreVO
//
//                self.navigationItem.title = genreVO?.name ?? ""
//            }
//
//        }
    }
}
extension MoreViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoreItemTableViewCell.self), for: indexPath) as? MoreItemTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.lblItemTitle.text = titleList[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}
