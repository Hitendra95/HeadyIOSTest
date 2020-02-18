//
//  MovieDetailsViewController.swift
//  Heady iOS Test
//
//  Created by Hitendra Dubey on 17/02/20.
//  Copyright © 2020 Hitendra Dubey. All rights reserved.
//

import UIKit
import TMDBSwift

class MovieDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var movieID: Int?
    let apiKey = "37f8d30f3fe0566faa70e400f371cab7"
    var movieData : MovieDetailAPIResponse?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        // Do any additional setup after loading the view.
        getData()
    }
    
    func getData()
    {
        TMDBConfig.apikey = apiKey
        guard let id = movieID else {return}
        MovieMDB.movie(movieID: id){
          apiReturn, movie in
            
            //print("mo:\(apiReturn) && \(movie)")
            do
            {
                guard let data = try apiReturn.json?.rawData() else {
                    return}
                let decoder = JSONDecoder()
                let decodeData = try decoder.decode(MovieDetailAPIResponse.self, from: data)
                self.movieData = decodeData
                self.tableView.reloadData()
                
                
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
    }
    
    func registerTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "MovieInformationTableViewCell", bundle: nil), forCellReuseIdentifier: MovieInformationTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "MoviePlotDetailTableViewCell", bundle: nil), forCellReuseIdentifier: MoviePlotDetailTableViewCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 400
        }
        else
        {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInformationTableViewCell") as! MovieInformationTableViewCell
            cell.selectionStyle = .none
            cell.movieImage.image = UIImage(named: "DummyScreen")
            guard let checkMovieData = movieData else {return cell}
            cell.movieName.text = checkMovieData.title
            if checkMovieData.production_companies?.count ?? 0 > 0
            {
                cell.movieReleaseDate.text = (checkMovieData.release_date ?? "")+" | "+(checkMovieData.production_companies?[0].name ?? "")
            }
            else
            {
                cell.movieReleaseDate.text = (checkMovieData.release_date ?? "")
            }
            cell.movieImage.layer.cornerRadius = 8
            cell.movieImage.clipsToBounds = true
            cell.backgroundColor = .clear
            var url = "https://image.tmdb.org/t/p/w500"
            url = url+(checkMovieData.poster_path ?? "")
            cell.movieImage.loadImageUsingCacheWithUrl(urlString: url)
            var count = Int(checkMovieData.vote_average ?? 0)
            count = count/2
            for i in 0..<count
            {
                cell.movieNumberOfStars[i].image = UIImage(named: "icons8-star-48")
            }
            print("cou :\(count)")
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoviePlotDetailTableViewCell") as! MoviePlotDetailTableViewCell
            guard let checkMovieData = movieData else {return cell}
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 7
            let attrString = NSMutableAttributedString(string: checkMovieData.overview ?? "")
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            cell.moviePlotDetails.attributedText = attrString
            cell.backgroundColor = .clear
            return cell
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
