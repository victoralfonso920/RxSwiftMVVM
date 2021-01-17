////  Created by Victor Hernandez.
//  Copyright © 2020 Victor Hernandez. All rights reserved.
//  Contact victoralfonso920@gmail.com

import Foundation
import RxSwift

class DetailViewModel{
    private var managerConnections = ManagerConections()
    private(set) weak var view: DetailView?
    private var router: DetailRouter?
    
    func bind(view: DetailView, router: DetailRouter){
        self.view = view
        self.router = router
    }
    
    func getMovieData(movieId: String) -> Observable<MovieDetail>{
        return managerConnections.getDetailMovies(movieId: movieId)
    }
    
}
