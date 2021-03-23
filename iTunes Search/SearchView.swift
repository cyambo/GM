//
//  SearchTableViewCell.swift
//  iTunes Search
//
//  Created by Cristiana Yambo on 3/22/21.
//

import UIKit

/// Delegate gets called when the search field is updated
protocol SearchDelegate: class {
    func searched(_ search: String)
}

/// Displays a search view
class SearchView: UIView, UITextFieldDelegate {
    let search = UITextField()
    let searchButton = UIButton()
    weak var delegate: SearchDelegate?
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    @objc func pressedSearch() {
        delegate?.searched(search.text ?? "")
    }

    /// Sets up the views and constraints
    private func setupView() {
        search.delegate = self
        searchButton.addTarget(self, action: #selector(pressedSearch), for: .touchUpInside)
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
        search.borderStyle = .roundedRect
        search.clearButtonMode = .always

        addSubviews()
        setupConstraints()
    }

    /// Adds the constraints
    private func setupConstraints() {
        var constraints = [
            search.leftAnchor.constraint(equalTo:leftAnchor, constant: 5),
            search.centerYAnchor.constraint(equalTo: centerYAnchor),
            search.heightAnchor.constraint(equalToConstant: 40),
            search.rightAnchor.constraint(equalTo: searchButton.leftAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(constraints)
        constraints = [
            searchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            searchButton.centerYAnchor.constraint(equalTo: search.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    /// Adds the subviews
    private func addSubviews() {
        let views = [search, searchButton]
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    // MARK: UITextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searched(textField.text ?? "")
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.searched("")
        return true
    }
}
