//
//  TableVC.swift
//  MemeMe
//
//  Created by aziz on 19/04/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation
import UIKit

class TableVC: UITableViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memes")!
        let meme = memes[indexPath.row]
        
        cell.textLabel?.text = (meme.bottomText + "..." + meme.topText)
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailedMeme") as! DetailedViewVC
        detailController.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        let createMeme = self.storyboard!.instantiateViewController(withIdentifier: "CreateMeme") as! CreateMemeVC
        
        present(createMeme, animated: true, completion: nil)
    }
}
