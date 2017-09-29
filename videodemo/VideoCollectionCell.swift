//
//  VideoCollectionCell.swift
//  videodemo
//
//  Created by Mallabelly, Manikanta on 9/28/17.
//  Copyright © 2017 Mallabelly, Manikanta. All rights reserved.
//

import Foundation
import UIKit

class VideoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var thumbnailImg: UIImageView?
    
    func configureWith(video: Video) {
        titleLbl.text = video.title
        thumbnailImg?.imageFromServerURL(urlString: video.thumbnailURL)
    }
}
