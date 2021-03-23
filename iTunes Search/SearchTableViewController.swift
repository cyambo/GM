//
//  SearchTableViewController.swift
//  iTunes Search
//
//  Created by Cristiana Yambo on 3/19/21.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    let loader = UIActivityIndicatorView()
    var data: ItunesSearch?
    var isLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ItunesTableViewCell.self, forCellReuseIdentifier: "ItunesCell")
        tableView.allowsSelection = false
    }

    /// Sets the data for the table and reloads it
    /// - Parameter data: Data for the table
    func loadData(_ data: ItunesSearch?) {
        self.data = data
        tableView.reloadData()
    }

    // MARK: Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (data?.resultCount ?? 0) > 0 ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.resultCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItunesCell", for: indexPath) as? ItunesTableViewCell,
              (data?.resultCount ?? 0) > indexPath.row,
              let item = data?.results?[indexPath.row] else { return UITableViewCell() }
        cell.configure(data: item)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }

}
