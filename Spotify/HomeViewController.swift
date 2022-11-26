//
//  HomeViewController.swift
//  Spotify
//
//  Created by Zardasht on 11/25/22.
//

import UIKit

class HomeViewController: UIViewController  {
    
    let menuBar = MenuBar()
    let playlistCellID = "PlayListCell"
    let mucic: [[Track]] = [playlists , artists , albums]
    
    lazy var collectionView: UICollectionView =  {
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PlayListCell.self, forCellWithReuseIdentifier: playlistCellID)
        collectionView.backgroundColor = .spotifyBlack
        collectionView.isPagingEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
        
    }()
    
    let colors: [UIColor] =  [.spotifyGreen , .systemBlue , .systemMint]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spotifyBlack
        menuBar.delegate = self
        layout()
        
        
    }
    
    private func layout() {
        view.addSubview(menuBar)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            //MenuBar
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBar.heightAnchor.constraint(equalToConstant: 42),
            
            //CollectionView
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: menuBar.bottomAnchor, multiplier: 2),
            collectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
}


//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mucic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playlistCellID, for: indexPath) as! PlayListCell
        
//        cell.backgroundColor = mucic[indexPath.row]
        cell.tracks = mucic[indexPath.item]
        return cell
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let index = targetContentOffset.pointee.x / view.frame.width
//        print(targetContentOffset.pointee.x)
//        print(index)
//        menuBar.selectItem(at: Int(index))
//    }
    
    //Scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.scrollIndicator(to: scrollView.contentOffset)
    }
    
}
//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
}

//MARK: - MenuBarDelegate
extension HomeViewController: MenuBarDelegate {
    func menuBarTapped(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
        
    }
}
