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
        NetworkManager.shared.photosAPICall(onCompletion: { (status, _) in
            if status {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.layoutIfNeeded()
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
                cell.layoutIfNeeded()
                cell.titleLabel.text = title
                cell.albumImageView.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    //MARK: UITableViewDelegate Method
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
