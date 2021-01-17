////  Created by Victor Hernandez.
//  Copyright © 2020 Victor Hernandez. All rights reserved.
//  Contact victoralfonso920@gmail.com

import Foundation
import RxSwift

class HomeViewModel{
    private weak var view:HomeView?
    private var router: HomeRouter?
    private var managerConnections = ManagerConections()
    
    func bind(view:HomeView, router:HomeRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getListMoviesData() -> Observable<[Movie]> {
        return managerConnections.getPopularMovies()
    }
    
    func makeDetailView(movieID: String){
        router?.navigateTodetailView(movieID: movieID)
    }
}
