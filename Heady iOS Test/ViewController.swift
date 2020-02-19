//
//  ViewController.swift
//  Heady iOS Test
//
//  Created by Hitendra Dubey on 17/02/20.
//  Copyright © 2020 Hitendra Dubey. All rights reserved.
//

import UIKit
import TMDBSwift

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var latestButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    
    let apiKey = "37f8d30f3fe0566faa70e400f371cab7"
    var movies = [Result]()
    var moviesToPresent = [Result]()
    var sortedMovies = [Result]()
    var searchingMovies = false
    var page = 1
    var lastContentOffSet = 0
    var sortType = "popularity_desc"
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Movie DB"
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        searchBar.tintColor = .black
        searchBar.backgroundColor = .clear
        searchBar.layer.cornerRadius = 4
        searchBar.clipsToBounds = true
        searchBar.delegate = self
        registerCollectionView()
        getData(pageNumber: page)
        setButtonLayer()
        
    }
    
    func setButtonLayer()
    {
        allButton.layer.cornerRadius = 2
        allButton.clipsToBounds = true
        //allButton.isEnabled = true
        allButton.backgroundColor = .gray
        allButton.setTitleColor(.white, for: .normal)
        
        popularButton.layer.cornerRadius = 2
        popularButton.clipsToBounds = true
        popularButton.backgroundColor = .gray
        popularButton.setTitleColor(.white, for: .normal)
        //popularButton.isEnabled = false
        
        latestButton.layer.cornerRadius = 2
        latestButton.clipsToBounds = true
        latestButton.backgroundColor = .gray
        latestButton.setTitleColor(.white, for: .normal)
        //latestButton.isEnabled = false
    }

    @IBAction func popularButtonPressed(_ sender: Any) {
        sortType = "popularity_desc"
        popularButton.backgroundColor = .white
        popularButton.setTitleColor(.black, for: .normal)
        
        allButton.backgroundColor = .gray
        allButton.setTitleColor(.white, for: .normal)
        latestButton.backgroundColor = .gray
        latestButton.setTitleColor(.white, for: .normal)
        getSortedData()
    }
    
    @IBAction func latestButtonPressed(_ sender: Any) {
        
        sortType = "primary_release_date_desc"
        allButton.backgroundColor = .gray
        allButton.setTitleColor(.white, for: .normal)
        
        latestButton.backgroundColor = .white
        latestButton.setTitleColor(.black, for: .normal)
        
        popularButton.backgroundColor = .gray
        popularButton.setTitleColor(.white, for: .normal)
        getSortedData()
        
    }
    @IBAction func allButtonPressed(_ sender: Any) {
        sortType = ""
        allButton.backgroundColor = .white
        allButton.setTitleColor(.black, for: .normal)
        latestButton.backgroundColor = .gray
        latestButton.setTitleColor(.white, for: .normal)
        popularButton.backgroundColor = .gray
        popularButton.setTitleColor(.white, for: .normal)
        getSortedData()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let text = searchBar.text else {return}
        searchingMovies = true
        print("selected text :\(text)")
        searchMovies(movieTitle: text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("secrh trc :\(searchText)")
        if searchText.count == 0
        {
            //searchBar.endEditing(true)
            //searchBar
            getUnsearchedList()
        }
        else
        {
            print("selected text :\(searchText)")
            searchMovies(movieTitle: searchText)
        }
    }
        
    func getUnsearchedList()
    {
        searchingMovies = false
        self.moviesToPresent.removeAll()
        self.moviesToPresent = movies
        self.collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        //searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    
    func searchMovies(movieTitle: String)
    {
        SearchMDB.movie(query: movieTitle, language: nil, page: nil, includeAdult: nil, year: nil, primaryReleaseYear: nil){
             data, movies in
             
                do
                {
                    //print("search :\(data.json)")
                    guard let jsonData = try data.json?.rawData() else {return}
                    let decoder = JSONDecoder()
                    print("search movie JSON Data:\(jsonData)")
                    let decodeRespone = try decoder.decode(MoviesDataResponse.self, from: jsonData)
                    guard let movie = decodeRespone.results else {return}
                    self.moviesToPresent.removeAll()
                    self.moviesToPresent = movie
                    self.collectionView.reloadData()
                    
                }
                catch
                {
                    print(error.localizedDescription)
                }
            
                
           }
    }
    
    
    func registerCollectionView()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MoviesCollectionViewCell.reuseIdentifier)
    }
    
    func getSortedData()
    {
            TMDBConfig.apikey = apiKey
            var params = [DiscoverParam]()
            if sortType != ""
            {
                switch sortType {
                case "popularity_desc":
                    params.append(DiscoverParam.sort_by(DiscoverSortByMovie.popularity_desc.rawValue))
                case "primary_release_date_desc":
                    params.append(DiscoverParam.sort_by(DiscoverSortByMovie.primary_release_date_desc.rawValue))
                default:
                    print("no filter")
                }
            }
            print("params :\(params)")
            DiscoverMovieMDB.discoverMovies(params: params, completion: { (data, movieArr) in
                do
                {
                    guard let jsonData = try data.json?.rawData() else {
                        return}
                    let decoder = JSONDecoder()
                    let decodeRespone = try decoder.decode(MoviesDataResponse.self, from: jsonData)
                    guard let movie = decodeRespone.results else {
                        return}
                    self.sortedMovies = movie
                    self.moviesToPresent.removeAll()
                    self.moviesToPresent = self.sortedMovies
                    self.collectionView.reloadData()
                    
                }
                catch
                {
                    print(error.localizedDescription)
                }
                
            })
    }
    
    func getData(pageNumber: Int)
    {

        TMDBConfig.apikey = apiKey
        var params = [DiscoverParam]()
        print("pageNumberv:\(pageNumber)")
        params.append(DiscoverParam.page(pageNumber))
        if sortType != ""
        {
            switch sortType {
            case "popularity_desc":
                params.append(DiscoverParam.sort_by(DiscoverSortByMovie.popularity_desc.rawValue))
            case "primary_release_date_desc":
                params.append(DiscoverParam.sort_by(DiscoverSortByMovie.primary_release_date_desc.rawValue))
            default:
                print("no filter")
            }
        }
        print("params :\(params)")
        DiscoverMovieMDB.discoverMovies(params: params, completion: { (data, movieArr) in
            do
            {
                guard let jsonData = try data.json?.rawData() else {
                    return}
                let decoder = JSONDecoder()
                let decodeRespone = try decoder.decode(MoviesDataResponse.self, from: jsonData)
                guard let movie = decodeRespone.results else {
                    return}
                self.movies = self.movies + movie
                self.moviesToPresent.removeAll()
                self.moviesToPresent = self.movies
                self.collectionView.reloadData()
                
            }
            catch
            {
                print(error.localizedDescription)
            }
            
        })
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return moviesToPresent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var posterUrl = "https://image.tmdb.org/t/p/w500"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
        cell.movieImage.layer.cornerRadius = 8
        cell.movieImage.clipsToBounds = true
        cell.movieImage.image = UIImage(named: "DummyScreen")
        guard let posterPath = moviesToPresent[indexPath.row].poster_path else {return cell}
        posterUrl = posterUrl+posterPath
        cell.movieImage.loadImageUsingCacheWithUrl(urlString: posterUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController else {return}
        vc.movieID = moviesToPresent[indexPath.row].id
        self.present(vc, animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if !searchingMovies
        {
            self.lastContentOffSet = Int(scrollView.contentOffset.y)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !searchingMovies
        {
            if collectionView.contentOffset.y >= (collectionView.contentSize.height - collectionView.frame.size.height) {
                print("move to top")
                page = page+1
                getData(pageNumber: page)
            }
        }
    }
    

}

