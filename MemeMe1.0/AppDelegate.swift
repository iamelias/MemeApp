//
//  AppDelegate.swift
//  MemeMe 2.0
//
//  Created by Elias Hall on 6/24/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes = [Meme]() //storing memes array for memeTableViewController and memeCollectionViewController

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

