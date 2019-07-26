//
//  MemeTableViewController.swift
//  MemeMe 2.0
//
//  Created by Elias Hall on 7/15/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var Table: UITableView!
    
    var meme: [Meme]! { //acessing memes array
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Table.reloadData() //refreshing tableView controller so meme appears
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.rowHeight = 90.0 // setting height of each cell
        return self.meme.count //getting number of rows in memes array 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let memeRep = self.meme[(indexPath as NSIndexPath).row] //pulling Meme saved data
        
        cell.textLabel?.text = ("\(memeRep.topText.text!)... \(memeRep.bottomText.text!)") //setting text
        cell.textLabel?.textAlignment = .center // aligning text to be in middle of cell
        cell.imageView?.image = memeRep.memedImage //setting meme image
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController //connecting to detailController
        
        detailController.memeDetail = self.meme[(indexPath as NSIndexPath).row]//data for detailController
        self.navigationController!.pushViewController(detailController, animated: true) //pushing to detailController
    }
    
    
}




