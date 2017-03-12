//
//  AddListVC.swift
//  Refrigerdata
//
//  Created by amota511 on 3/10/17.
//  Copyright © 2017 Aaron Motayne. All rights reserved.
//

import UIKit

class AddListVC: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        createBlurView()
        
    }
    
    func createBlurView() {
        
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame.origin.x = 0
        blurView.frame.origin.y = 0
        blurView.frame.size.width = self.view.bounds.width
        blurView.frame.size.height = self.view.bounds.height
        
        let dismissTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeView))
        blurView.addGestureRecognizer(dismissTapGestureRecognizer)
        
        self.view.addSubview(blurView)
        
        setupContainerView(blurView: blurView)
    }
    
    func setupContainerView(blurView: UIVisualEffectView){
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.95, height: self.view.frame.width / 1.25))
        containerView.center = CGPoint(x: self.view.center.x, y: self.view.center.y + self.view.center.y / 6)
        containerView.backgroundColor = UIColor.white //(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        containerView.alpha = 0
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        
        
        self.view.addSubview(containerView)
        animateContainerView(containerView: containerView)
        
        
        setupAddKickLabel(blurView: blurView)
        
    }
    
    func animateContainerView(containerView: UIView) {
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 3.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut] , animations: {
            
            containerView.frame.size.height = CGFloat(self.view.frame.width * 0.95)
            containerView.center = self.view.center
            
            
            //self.addPhotoViewDescriptionLabel(containerView: containerView, collectionView: sneakerPhotosCV)
        }) { (completion) in
            
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            
            containerView.alpha = 1.0
            
        }) { (completion) in
            
        }
    }
    
    func setupAddKickLabel(blurView: UIVisualEffectView) {
        let addKickLabel = UILabel()
        addKickLabel.text = "Add List"
        addKickLabel.textColor = UIColor.white
        addKickLabel.textAlignment = .center
        addKickLabel.attributedText = NSAttributedString(string: addKickLabel.text!, attributes: [NSUnderlineStyleAttributeName: 1, NSFontAttributeName : UIFont.systemFont(ofSize: 21.0)])
        
        blurView.addSubview(addKickLabel)
        addKickLabel.backgroundColor = UIColor.clear
        addKickLabel.alpha = 0
        addKickLabel.frame.size.width = blurView.frame.width
        addKickLabel.frame.size.height = blurView.frame.height / 16
        addKickLabel.center.x = blurView.center.x
        addKickLabel.frame.origin.y = -addKickLabel.frame.height
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut] , animations: {
            addKickLabel.alpha = 1.0
            addKickLabel.center.y = addKickLabel.frame.height * 2
        })
    }
    

    
    func removeView() {
        print("removeView function sucessfully called.")
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    

    
    func addPhotoViewDescriptionLabel(containerView: UIView, collectionView: UICollectionView){
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Add up to 6 photos."
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 17.5).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
        descriptionLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/12).isActive = true
        
    }


}
