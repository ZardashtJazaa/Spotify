//
//  ViewController.swift
//  Spotify
//
//  Created by Zardasht on 11/23/22.
//

import UIKit
//MARK: - Controllers

//class MusicViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBlue
//    }
//
//
//}
//class PodcastViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .purple
//    }
//
//
//}

class TitleViewController: UIViewController {

    var musicBarbuttonItem: UIBarButtonItem!
    var podCastBarButtonItem: UIBarButtonItem!
    
    let container = Container()
    let viewControllers: [UIViewController] = [HomeViewController() , HomeViewController()]
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        setUpView()
    }
    
    //MARK: - Animations
    private func animatrTransition(fromVC: UIViewController , toVC: UIViewController , completion: @escaping((Bool) -> Void)) {
        
        guard let fromView = fromVC.view ,
              let fromIndex = getIndex(forViewController: fromVC),
              let toView = toVC.view,
              let toIndex = getIndex(forViewController: toVC)
        else {
            return
        }
        
        let frame = fromVC.view.frame
        var toFrameStart = frame
        var fromFrameEnd = frame
        
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        print("Frame.Oringin.x = \(frame.origin.x) and frame.width = \(frame.width)")
        print("fromFrameEnd \(fromFrameEnd)")
        print("toFrameStart \(toFrameStart)")
        
        
        toView.frame = toFrameStart
        print("toView.frame after updae \(toView.frame)")
        
        UIView.animate(withDuration: 0.5, animations: {
            fromView.frame = fromFrameEnd
            toView.frame = frame
            print("fromView.frame in animations \(fromView.frame)")
            print("toView.frame in animations \(toView.frame)")
        }) { success in
            completion(success)
        }
    }
    //MARK: - GetViewController
    private func getIndex(forViewController vc: UIViewController) -> Int? {
        
        for (index , thisVC) in viewControllers.enumerated() {
            if thisVC == vc  { return index }
        }
        return nil
        
    }
    //MARK: - setUpViews
    private func setUpView() {
        
        guard let containerView = container.view else { return }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalToSystemSpacingBelow:
                                                view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        
        ])
        musicTapped()
    }
    
    //MARK: - SetupNavBar
    func setUpNavBar()  {
        navigationItem.leftBarButtonItems =  [musicBarbuttonItem , podCastBarButtonItem]
        //Hide bottom shade Pixel
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        musicBarbuttonItem = makeBarButtonItem(text: "Music", selector: #selector(musicTapped))
        podCastBarButtonItem = makeBarButtonItem(text: "Podcasts", selector: #selector(podCastTapped))
        
    }
    
    
    //MakeButton
    private func makeBarButtonItem(text: String , selector: Selector) -> UIBarButtonItem {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: selector, for: .primaryActionTriggered)
        
        let attribute = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle).withTraits(traits:[.traitBold]),NSAttributedString.Key.foregroundColor: UIColor.label]
        let attributedText = NSMutableAttributedString(string: text,attributes: attribute)
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
    
    
    //MARK: - Actions
    @objc func musicTapped() {
        //Show music viewController
        if container.children.first == viewControllers[0] { return }
        container.add(viewControllers[0])
//        viewControllers[1].remove()
        animatrTransition(fromVC: viewControllers[1], toVC: viewControllers[0]) { _ in
            self.viewControllers[1].remove()
        }
        
        UIView.animate(withDuration: 0.5)   {
            self.musicBarbuttonItem.customView?.alpha = 1.0
            self.podCastBarButtonItem.customView?.alpha = 0.5
        }
    }
    
    @objc func podCastTapped() {
        //Show podcastViewController
        if container.children.first == viewControllers[1] { return }
        container.add(viewControllers[1])
//        viewControllers[0].remove()
        
        animatrTransition(fromVC: viewControllers[0], toVC: viewControllers[1]) { _ in
            self.viewControllers[0].remove()
        }
        
        UIView.animate(withDuration: 0.5)   {
            self.musicBarbuttonItem.customView?.alpha = 0.5
            self.podCastBarButtonItem.customView?.alpha = 1.0
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - ChildView
extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
                    
}


