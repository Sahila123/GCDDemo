//
//  ViewController.swift
//  ThreadAssignment
//
//  Created by Mirajkar on 11/06/21.
//  Copyright © 2021 Mirajkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Global varibles
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NetworkManager.shared.photosAPICall(onCompletion: { message in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NetworkManager.shared.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        
        let albumObj = NetworkManager.shared.albums[indexPath.row]
        NetworkManager.shared.fetchCellImage(albumObj: albumObj) { (data, title) in
            DispatchQueue.main.async {
                cell.titleLabel.text = title
                cell.albumImageView.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    //MARK: UITableViewDelegate Method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}
