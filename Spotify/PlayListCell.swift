//
//  PlayListCell.swift
//  Spotify
//
//  Created by Zardasht on 11/25/22.
//

import UIKit

struct Track {
    let imageName: String
    let title: String
    let artist: String
    
}
//Constance
let trackCellHeight: CGFloat = 72
let trackCellWidth: CGFloat = 72

//MARK: - PlayListCell
class PlayListCell:UICollectionViewCell {
    
    let trackCellID = "trackCell"
    var tracks: [Track]?
    
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: trackCellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .spotifyBlack
        collectionView.dataSource = self
        
        collectionView.delegate = self
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
}
//MARK: - PlayListCell + Extentions
extension PlayListCell:UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let track = tracks else { return 0 }
        return track.count
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trackCellID, for: indexPath) as? TrackCell else { return UICollectionViewCell() }
        cell.track = tracks?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: trackCellHeight)
    }
    
    
}



//MARK: - TrackCell
class TrackCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    
    var track: Track? {
        didSet {
            guard let track = track else { return }
            let image =  UIImage(named: track.imageName) ?? UIImage(named: "PlaceHolder")
            
            imageView.image = image
            titleLabel.text = track.title
            subTitleLabel.text = track.artist
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body).withTraits(traits: .traitBold)
        subTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subTitleLabel.alpha = 0.7
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = makeStackView(axis: .vertical)
        stackView.spacing = 6.0
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        //stackView.contentMode = .left
        addSubview(imageView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            //ImageView
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: trackCellHeight),
            imageView.widthAnchor.constraint(equalToConstant: trackCellWidth),
            //StackView
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: imageView.trailingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 3),
        ])
        
    }
    
    
}
