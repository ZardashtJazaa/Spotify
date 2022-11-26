//
//  MenuBar.swift
//  Spotify
//
//  Created by Zardasht on 11/25/22.
//

import UIKit

protocol MenuBarDelegate: AnyObject {
    func menuBarTapped(index: Int)
}

class MenuBar: UIView {
    
    let playListButton: UIButton!
    let artistButton: UIButton!
    let albumsButton:UIButton!
    var buttons: [UIButton]!
    
    let indicator = UIView()
    var indicatorLeading: NSLayoutConstraint?
    var indicatorTrailing: NSLayoutConstraint?
    
    let leadingPadding = 16.0
    let buttonSpace = 36.0
    
    weak var delegate: MenuBarDelegate?
    
    override init(frame: CGRect) {
        
        playListButton = makeButton(withText: "Playlists")
        artistButton = makeButton(withText: "Artists")
        albumsButton = makeButton(withText: "Albums")
        //ButtonsArray
        buttons = [playListButton , artistButton , albumsButton]
        
        super.init(frame: .zero)
        
        playListButton.addTarget(self, action: #selector(playListButtonTapped), for: .primaryActionTriggered)
        artistButton.addTarget(self, action: #selector(artistsButtonTapped), for: .primaryActionTriggered)
        albumsButton.addTarget(self, action: #selector(albumsTapped), for: .primaryActionTriggered)
        setAlpha(for: playListButton)
        styleIndicator()
        layout()
     
        
    }
    //StyleIndicator
    private func styleIndicator() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = .spotifyGreen
    }
    
    //Layout
    private func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(playListButton)
        addSubview(artistButton)
        addSubview(albumsButton)
        addSubview(indicator)
        
        NSLayoutConstraint.activate([
            //PlayListButton
            playListButton.topAnchor.constraint(equalTo: topAnchor),
            playListButton.leadingAnchor.constraint(equalTo: leadingAnchor ,constant: leadingPadding),
            //ArtistButton
            artistButton.topAnchor.constraint(equalTo: topAnchor),
            artistButton.leadingAnchor.constraint(equalTo: playListButton.trailingAnchor, constant: buttonSpace),
            //AlbumsButton
            albumsButton.topAnchor.constraint(equalTo: topAnchor),
            albumsButton.leadingAnchor.constraint(equalTo: artistButton.trailingAnchor, constant: buttonSpace),
            //IndicatorBar
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 3),
            
        ])
        //indicator.Leading + Trailing
        indicatorLeading = indicator.leadingAnchor.constraint(equalTo: playListButton.leadingAnchor)
        indicatorTrailing = indicator.trailingAnchor.constraint(equalTo: playListButton.trailingAnchor)
        indicatorLeading?.isActive = true
        indicatorTrailing?.isActive = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

//MARK: - Extentions
extension MenuBar {
    
    @objc private func playListButtonTapped()  {
        delegate?.menuBarTapped(index: 0)
    }
    
    @objc private func artistsButtonTapped()  {
        delegate?.menuBarTapped(index: 1)
    }
    
    @objc private func albumsTapped()  {
        delegate?.menuBarTapped(index: 2)
    }
    
//     func selectItem(at index: Int) {
//        animateIndicator(to: index)
//    }
    
    private func animateIndicator(to index: Int) {
        var button: UIButton
        switch index {
        case 0:
            button = playListButton
        case 1:
            button = artistButton
        case 2:
            button = albumsButton
        default:
            button = playListButton
        }
        
        setAlpha(for: button)
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func setAlpha(for button :UIButton) {
        playListButton.alpha = 0.5
        artistButton.alpha = 0.5
        albumsButton.alpha = 0.5
            
        button.alpha = 1.0
    }
    
    //MARK: - Indicator Calculations
    func scrollIndicator(to contentOffset: CGPoint) {
        let index = Int(contentOffset.x / frame.width)
        let atScrollStart = Int(contentOffset.x) % Int(frame.width) == 0
        
//        print(atScrollStart)
        if atScrollStart {
            return
        }
        
        //Determine Percent scrolled relative to index
        let percentScrolled: CGFloat
        switch index {
        case 0:
            percentScrolled = contentOffset.x / frame.width - 0
        case 1:
            percentScrolled = contentOffset.x / frame.width - 1
        case 2:
            percentScrolled = contentOffset.x / frame.width  - 2
        default:
            percentScrolled = contentOffset.x / frame.width
        }
        
        //Determine Button
        var fromButton: UIButton
        var toButton: UIButton
        
        switch index {
        case 2:
            fromButton = buttons[index]
            toButton = buttons[index - 1]
            
        default:
            fromButton = buttons[index]
            
            toButton = buttons[index + 1]
        }
        
        //Animate Alpha of buttons
        switch index {
        case 2:
            break
        default:
            fromButton.alpha = fmax(0.5, 1 - percentScrolled)
            toButton.alpha =  fmax(0.5, percentScrolled)
        }
        
        //Determine Width
        let fromWidth = fromButton.frame.width
        
        let toWidth = toButton.frame.width

        let sectionsWith: CGFloat
        switch index  {
        case 0:
            sectionsWith = leadingPadding + fromWidth + buttonSpace
        default:
            sectionsWith = fromWidth + buttonSpace

        }

        //Normalize XScroll
        let sectionFraction = sectionsWith / frame.width


        
        let x = contentOffset.x * sectionFraction

        let buttonWidthDiff = fromWidth - toWidth

        let widthOffset = buttonWidthDiff * percentScrolled
        
        //Determine leading Fx
        let fx: CGFloat
        switch index {
        case 0:
            if x < leadingPadding {
                fx = x
            } else {
                print(x)
                fx = x - leadingPadding * percentScrolled
            }
            
        case 1:
            print(x)
            fx = x + 16
            
        case 2:
            print(x)
            fx = x
        default:
            fx = x
        }
        indicatorLeading?.constant = fx
        
        //Determine Trailing Fx
        let yFxTrailing: CGFloat
        switch index {
        case 0:
            yFxTrailing = fx - widthOffset
        case 1:
            yFxTrailing = fx - widthOffset - leadingPadding
        case 2:
            yFxTrailing = fx - widthOffset - leadingPadding / 2
        default:
            yFxTrailing = fx - widthOffset - leadingPadding
        }
        
        indicatorTrailing?.constant = yFxTrailing
        
    }
    
}


private func makeButton(withText text: String) -> UIButton {
    
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(text, for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    
    return button
}

