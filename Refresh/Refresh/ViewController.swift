//
//  ViewController.swift
//  Refresh
//
//  Created by Guiyang Li on 2019/6/12.
//  Copyright © 2019 Xin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    var number = 20
    var tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "RHRefresh"
        self.edgesForExtendedLayout = []

        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        view.addSubview(tableView)
        tableView.frame = view.bounds

        let footer = RHRefreshFooter(refreshScrollView: tableView)
        footer.refreshHandler = {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
                self.number = self.number + 10
                self.tableView.reloadData()
                footer.endRefresh()

                if self.number > 80 {
                    footer.hasMoreData = false
                }
            }
        }

//        let header = RHRefreshHeader(refreshScrollView: tableView)
//        header.refreshHandler = {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
//                self.number = 20
//                self.tableView.reloadData()
//                header.endRefresh()
//
//                footer.hasMoreData = true
//            }
//        }
//        header.beginRefresh()

        // Do any additional setup after loading the view, typically from a nib.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return number
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel!.text = "第\(indexPath.row + 1)个"
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

