////  Created by Victor Hernandez.
//  Copyright © 2020 Victor Hernandez. All rights reserved.
//  Contact victoralfonso920@gmail.com

import UIKit
import RxSwift
import RxCocoa

class HomeView: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activity: UIActivityIndicatorView!
    
    private var router = HomeRouter()
    private var viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()
    
    private var movies = [Movie]()
    
    private var filteredMovies = [Movie]()
    
    lazy var searchController: UISearchController = ({
        let controller = UISearchController(searchResultsController: nil)
        controller.hidesNavigationBarDuringPresentation = true
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.sizeToFit()
        controller.searchBar.placeholder = "Buscar pélicula"
        return controller
    })()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "The Movies App"
        configureTableView()
        viewModel.bind(view: self, router: router)
        getData()
        manageSearchBarController()
    }
    
    private func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "CustomMoviecell", bundle: nil), forCellReuseIdentifier: "CustomMoviecell")
    }
    
    private func getData(){
        return viewModel.getListMoviesData()
            .subscribeOn(MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { movies in
                self.movies = movies
                self.reloadTableView()
            }, onError: { error in
                print("error \(error)")
            }, onCompleted: {
            }).disposed(by: disposeBag)
    }
    
    private func reloadTableView(){
        DispatchQueue.main.async {
            self.activity.stopAnimating()
            self.activity.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    private func manageSearchBarController(){
        let searchBar = searchController.searchBar
        tableView.tableHeaderView = searchBar
        tableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.size.height)
        
        searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { (result) in
                self.filteredMovies = self.movies.filter({ movie in
                    self.reloadTableView()
                    return movie.title.contains(result)
                })
            })
            .disposed(by: disposeBag)
    }
    
}

//extensions
extension HomeView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return self.filteredMovies.count
        }else{
            return self.movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMoviecell") as! CustomMoviecell
        
        //verify is filter
        var dataMovie = [Movie]()
        
        if searchController.isActive && searchController.searchBar.text != ""{
            dataMovie = filteredMovies
        }else{
            dataMovie = movies
        }
            cell.imageMovie.imgFromServerURL(urlString: "\(Constants.URL.urlImages+dataMovie[indexPath.row].image)", placeHolderImage: UIImage(named: "claqueta")!)
        cell.titleMovie.text = dataMovie[indexPath.row].title
        cell.descriptionMovie.text = dataMovie[indexPath.row].sinopsis
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var idMovie = 0
        if searchController.isActive && searchController.searchBar.text != ""{
            idMovie = self.filteredMovies[indexPath.row].movieID
        }else{
            idMovie = self.movies[indexPath.row].movieID
        }
        viewModel.makeDetailView(movieID: String(idMovie))
    }
}
//home view
extension HomeView:UISearchControllerDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchController.isActive = false
        reloadTableView()
    }
}
