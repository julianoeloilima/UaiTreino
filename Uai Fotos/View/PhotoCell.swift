//
//  PhotoCell.swift
//  Uai Fotos
//
//  Created by Aloc SP08608 on 14/12/2017.
//  Copyright © 2017 Uai Fotos. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell : UICollectionViewCell {
    
    var delegate : PhotoCellDelegate?
    
    @IBOutlet weak var photoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        let tapGestureRecognizerImage = UITapGestureRecognizer(target: self, action: #selector(handleTapOnImage(_:)))
//
//        self.photoImage.addGestureRecognizer(tapGestureRecognizerImage)
//        self.photoImage.isUserInteractionEnabled = true
    }

    @objc func handleTapOnImage(_ : UITapGestureRecognizer)  {
        if self.delegate != nil {
            self.delegate?.feedPhotoCell(self, imageTap: self.photoImage)
        }
    }
}

protocol PhotoCellDelegate {
    
    func feedPhotoCell(_ photoCell: PhotoCell, imageTap image : UIImageView)

}
