//
//  DetailedViewVC.swift
//  MemeMe
//
//  Created by aziz on 19/04/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation
import UIKit

class DetailedViewVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        imageView.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
