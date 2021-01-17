////  Created by Victor Hernandez.
//  Copyright © 2020 Victor Hernandez. All rights reserved.
//  Contact victoralfonso920@gmail.com

import UIKit

class DetailRouter{
    var viewController: UIViewController{
        return createViewController()
    }
    
    var movieID: String
    private var sourceView:UIViewController?
    
    
    init(movieID: String? = ""){
        self.movieID = movieID ?? ""
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    private func createViewController()-> UIViewController {
        let view = DetailView(nibName: "DetailView", bundle: Bundle.main)
        view.movieID = self.movieID
        return view
    }
}
