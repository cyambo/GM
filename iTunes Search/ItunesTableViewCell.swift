//
//  ItunesTableViewCell.swift
//  iTunes Search
//
//  Created by Cristiana Yambo on 3/19/21.
//

import UIKit

class ItunesTableViewCell: UITableViewCell {
    let artistName = UILabel()
    let trackName = UILabel()
    let releaseDate = UILabel()
    let trackPrice = UILabel()
    let genre = UILabel()
    let art = UIImageView()
    var currentImage: URL?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    /// Configures the cell with data from the server
    /// - Parameter data: data from server
    func configure(data: ItunesResult) {
        artistName.text = data.artistName
        trackName.text = data.trackName
        releaseDate.text = "Release: \(data.getReleaseDate())"
        trackPrice.text = data.getPrice()
        genre.text = data.primaryGenreName
        loadImage(data.artworkUrl100)
    }

    /// Loads a cover image for the cell
    /// - Parameter img: image to load
    private func loadImage(_ img: URL) {
        //if we happen to be loading the same image, then just return and let it load
        if currentImage == img {
            return
        }
        //set the image to nil
        self.art.image = nil
        //set the current image url to the one we are loading
        currentImage = img
        //then try to load it
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: img) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        //if the current image differs that means we are in a background thread for a cell
                        //that gor reconfigured, so if we differ, just ignore it
                        if self?.currentImage == img {
                            self?.art.image = image
                        }
                    }
                }
            }
        }
    }

    /// Sets the constraints
    private func setupConstraints() {
        var constraints = [
            art.widthAnchor.constraint(equalToConstant: 95),
            art.heightAnchor.constraint(equalTo: art.widthAnchor),
            art.leftAnchor.constraint(equalTo: self.leftAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        constraints = [
            artistName.leftAnchor.constraint(equalTo: art.rightAnchor, constant: 5),
            artistName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            artistName.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            artistName.heightAnchor.constraint(equalToConstant: 22)
        ]
        NSLayoutConstraint.activate(constraints)

        constraints = [
            trackName.leftAnchor.constraint(equalTo: artistName.leftAnchor),
            trackName.rightAnchor.constraint(equalTo: artistName.rightAnchor),
            trackName.topAnchor.constraint(equalTo: artistName.bottomAnchor, constant: 5),
            trackName.heightAnchor.constraint(equalToConstant: 18)
        ]
        NSLayoutConstraint.activate(constraints)

        constraints = [
            genre.leftAnchor.constraint(equalTo: artistName.leftAnchor),
            genre.rightAnchor.constraint(equalTo: artistName.rightAnchor),
            genre.topAnchor.constraint(equalTo: trackName.bottomAnchor, constant: 5),
            genre.heightAnchor.constraint(equalToConstant: 14)
        ]
        NSLayoutConstraint.activate(constraints)

        constraints = [
            releaseDate.leftAnchor.constraint(equalTo: artistName.leftAnchor),
            releaseDate.topAnchor.constraint(equalTo: genre.bottomAnchor,constant: 5),
            releaseDate.heightAnchor.constraint(equalToConstant: 12)
        ]
        NSLayoutConstraint.activate(constraints)

        constraints = [
            trackPrice.rightAnchor.constraint(equalTo: trackName.rightAnchor),
            trackPrice.topAnchor.constraint(equalTo: releaseDate.topAnchor),
            trackPrice.heightAnchor.constraint(equalTo: releaseDate.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    /// Sets up all the views for the cell
    private func setupView() {
        addSubviews()
        setupConstraints()
        setupFonts()

    }

    /// Sets the fonts for the cell
    private func setupFonts() {
        artistName.font = UIFont.boldSystemFont(ofSize: 18)
        trackName.font = UIFont.systemFont(ofSize: 14)
        genre.font = UIFont.systemFont(ofSize: 13)
        releaseDate.font = UIFont.systemFont(ofSize: 12)
        trackPrice.font = UIFont.italicSystemFont(ofSize: 12)
    }

    /// Adds the views to the cell
    private func addSubviews() {
        let views = [artistName, trackName, releaseDate, trackPrice, genre, art]
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }

}
