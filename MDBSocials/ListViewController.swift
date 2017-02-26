//
//  ListViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/25/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    var navBar: UINavigationBar!
    var purpleColor = UIColor(red: 92/255, green: 121/255, blue: 254/255, alpha: 1)
    var names: [String] = []
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpTableView()
    }

    func setUpNavBar() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.09))
        navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navBar.tintColor = UIColor.white
        navBar.barTintColor = purpleColor
        let navItem = UINavigationItem(title: "Interested Users")
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        navBar.items = [navItem]
        view.addSubview(navBar)
    }
    
    func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: navBar.frame.maxY, width: view.frame.width, height: view.frame.height))
        //Register the tableViewCell you are using
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listCell")
        //Set properties of TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50 / 2, right: 0)
        tableView.tableFooterView = UIView() // gets rid of the extra cells beneath
        view.addSubview(tableView)
    }
    
    func goBack() {
        dismiss(animated: true, completion: nil)
    }

}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListTableViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview() //remove stuff from cell before initializing
        }
        cell.awakeFromNib() //initialize cell
        cell.name.text = names[indexPath.row]
        cell.name.sizeToFit()
        cell.name.frame.origin.x = view.frame.width / 2 - cell.name.frame.width / 2
        cell.name.frame.origin.y = cell.contentView.frame.height / 2 - cell.name.frame.height / 2
        return cell
    }

        
}

