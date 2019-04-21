//
//  CollectionVC.swift
//  MemeMe
//
//  Created by aziz on 19/04/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation
import UIKit

class CollectionVC: UICollectionViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (5 * space)) / 6.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memes", for: indexPath) as! MemeCollectionCell
        let meme = memes[indexPath.row]
        
        cell.memeImage.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailedMeme") as! DetailedViewVC
        detailController.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "CreateMeme") as! CreateMemeVC
        
        present(detailController, animated: true, completion: nil)
    }
}
