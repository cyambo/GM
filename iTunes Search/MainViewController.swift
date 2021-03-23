//
//  MainViewController.swift
//  iTunes Search
//
//  Created by Cristiana Yambo on 3/22/21.
//

import UIKit

class MainViewController: UIViewController, SearchDelegate {
    let searchTable = SearchTableViewController()
    let network = Network()
    let loader = UIImageView()
    
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var searchView: SearchView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.delegate = self
        setupView()
        loader.image = UIImage.init(named: "Loader")
    }

    /// Sets the table and loader views
    private func setupView() {
        tableView.addSubview(searchTable.view)
        searchTable.view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [
            searchTable.view.topAnchor.constraint(equalTo: tableView.topAnchor),
            searchTable.view.rightAnchor.constraint(equalTo: tableView.rightAnchor),
            searchTable.view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            searchTable.view.leftAnchor.constraint(equalTo: tableView.leftAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        tableView.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        constraints = [
            loader.widthAnchor.constraint(equalToConstant: 70),
            loader.heightAnchor.constraint(equalTo: loader.widthAnchor),
            loader.centerYAnchor.constraint(equalTo: searchTable.view.centerYAnchor),
            loader.centerXAnchor.constraint(equalTo: searchTable.view.centerXAnchor)
        ]
        loader.isHidden = true
        NSLayoutConstraint.activate(constraints)
    }

    /// Search delegate
    /// - Parameter search: Search string
    func searched(_ search: String) {
        //if the search is empty, simply empty out the table
        if search == "" {
            searchTable.loadData(nil)
        //otherwise show the loader and make a network request
        } else {
            showLoader()
            network.sendRequest(search) { (data) in

                DispatchQueue.main.async {
                    //hide the loader on complete and load the data
                    self.hideLoader()
                    self.searchTable.loadData(data)
                }
            }
        }
    }

    /// Shows the loader and animates it
    func showLoader() {
        loader.isHidden = false
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        loader.layer.add(rotation, forKey: "rotationAnimation")
    }

    /// Hides the loader
    func hideLoader() {
        loader.isHidden = true
        loader.layer.removeAllAnimations()
    }
}
