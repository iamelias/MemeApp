//
//  MemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Elias Hall on 7/22/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memeDetail: Meme! //storing Meme Data in memeDetail for detailController
    
    @IBOutlet weak var detailImageView: UIImageView! //connecting to ImageView in DetailController storyboard
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true //hiding tabBar when detailController appears
        
        self.detailImageView!.image = memeDetail.memedImage //making the imageView the saved memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false //readding tabBar when detailController closes
        
    }
    
}

