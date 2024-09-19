//
//  MovieCell.swift
//  TurkcellApi3
//
//  Created by Sefa Aycicek on 19.09.2024.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    
    func configure(data : MovieUIModel) {
        movieLabel.text = data.title
        //movieLabel.inset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        indicator.startAnimating()
        movieImageView.kf.setImage(with: data.url) { result in
            print(try? result.get().image.size)
            self.indicator.stopAnimating()
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
