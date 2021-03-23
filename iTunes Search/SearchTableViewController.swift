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
        //there is always one section because if there are no results it shows in the table
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if there are no results, we still have one item because the first cell shows 'no results'
        guard let resultCount = data?.resultCount else { return 1 }
        return resultCount == 0 ? 1 : resultCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if there are no results show the message in the table
        if data?.resultCount ?? 0 == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No Results"
            return cell
        }
        //otherwise populate the cell with the data
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
