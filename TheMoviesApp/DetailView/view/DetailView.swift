//  Created by Victor Hernandez.
//  Copyright © 2020 Victor Hernandez. All rights reserved.
//  Contact victoralfonso920@gmail.com

import UIKit
import RxSwift
class DetailView: UIViewController {
    
    @IBOutlet private weak var titleHeader: UILabel!
    @IBOutlet private weak var ImageFilm: UIImageView!
    @IBOutlet private weak var originaldate: UILabel!
    @IBOutlet private weak var voteAverage: UILabel!
    @IBOutlet private weak var releasedate: UILabel!
    @IBOutlet private weak var descriptionMovie: UILabel!
    
    
    private var router = DetailRouter()
    private var viewmodel = DetailViewModel()
    private var disposeBag = DisposeBag()
    var movieID:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataAndShowDetailMovie()
        viewmodel.bind(view: self, router: router)
    }
    
    private func getDataAndShowDetailMovie() {
        guard let idMovie = movieID else {return}
        return viewmodel.getMovieData(movieId: idMovie).subscribe(
            onNext:{ movie in
                self.showMovieData(movie: movie)
        }, onError: { error in
            print("Ha ocurrido un error \(error)")
        }).disposed(by: disposeBag)
    }
    
    func showMovieData(movie: MovieDetail){
        DispatchQueue.main.async {
            self.titleHeader.text = movie.title
            self.ImageFilm.imgFromServerURL(urlString: Constants.URL.urlImages+movie.posterPath, placeHolderImage: UIImage(named: "claqueta")!)
            self.descriptionMovie.text = movie.overview
            self.releasedate.text = movie.releaseDate
            self.voteAverage.text = String(movie.voteAverage)
            
        }
    }
    
    
}
