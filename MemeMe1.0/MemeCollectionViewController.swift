//
//  MemeCollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Elias Hall on 7/15/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit

class MemeColletionViewController: UICollectionViewController {
    
    @IBOutlet weak var Collec: UICollectionView!
    
    var meme: [Meme]! { //accessing memes array
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Collec.reloadData() //refreshing CollectionController so updated memes appear
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.meme.count //returning number of memes for Collection Controller
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollecCell", for: indexPath) as! MemeCollectionViewCell //connecting to reusable cell
        let memeIm = self.meme[(indexPath as NSIndexPath).row] //pulling saved Meme data
        
        cell.memeImageView?.image = memeIm.memedImage //adding the cell image to CollectionController
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController //connecting to DetailController
        detailController.memeDetail = self.meme[(indexPath as NSIndexPath).row]//Data for detailController
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController!.pushViewController(detailController, animated: true)//pushing to DetailController
    }
}



