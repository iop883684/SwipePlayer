//
//  PlayerViewController.swift
//  test2
//
//  Created by Dustin Doan on 11/28/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

import UIKit

protocol PlayerDelegate:NSObjectProtocol {
    func didTapOnPlayer()
    func scrollStatus(isTop:Bool)
}

class PlayerViewController: UIViewController {

    weak var delegate:PlayerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tap(){
        
        delegate?.didTapOnPlayer()
        
    }

}

extension PlayerViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Row: \(indexPath.row)"
        return cell
        
    }
    
}

extension PlayerViewController: UITableViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset.y)
        
        if scrollView.contentOffset.y <= 0 {
            
            delegate?.scrollStatus(isTop: true)
            
        } else{
            
            delegate?.scrollStatus(isTop: false)
            
        }
        
    }
    
    
    
}
