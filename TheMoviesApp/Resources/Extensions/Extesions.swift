////  Created by Victor Hernandez.
//  Copyright © 2020 Victor Hernandez. All rights reserved.
//  Contact victoralfonso920@gmail.com

import UIKit

extension UIImageView{
    func imgFromServerURL(urlString: String, placeHolderImage: UIImage){
        if self.image == nil {
            self.image = placeHolderImage
        }
        URLSession.shared.dataTask(with: URL(string: urlString)!){ (data, response, error) in
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                guard let data = data else { return }
                let image = UIImage(data: data)
                self.image = image
            }
        }.resume()
    }
}
