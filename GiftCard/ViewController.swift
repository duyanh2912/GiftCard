//
//  ViewController.swift
//  GiftCard
//
//  Created by Duy Anh on 2/13/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {
    @IBOutlet weak var topThings: UIImageView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var priceLabel: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var bottomThings: UIView!
    @IBOutlet weak var alphaView: UIImageView!
    var giftWrapImageView: UIImageView!
    var imageArray = [CGImage]()
    
    @IBOutlet weak var giftCardView: UIView!
    
    @IBOutlet weak var label1: UIImageView!
    @IBOutlet weak var label2: UIImageView!
    @IBOutlet weak var label3: UIImageView!
    @IBOutlet weak var label4: UIImageView!
    @IBOutlet weak var label5: UIImageView!
    
    @IBOutlet weak var base: AnimatableImageView!
    @IBOutlet weak var chekoutButton: UIButton!
    
    var snapView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageToArray()
        buyButton.addTarget(self, action: #selector(tappedBuyButton), for: .touchUpInside)
        chekoutButton.addTarget(self, action: #selector(tappedCheckoutButton), for: .touchUpInside)
        configTopThings()
        containerView.center = giftCardView.center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let renderer = UIGraphicsImageRenderer(size: giftCardView.bounds.size)
        let image = renderer.image { ctx in
            giftCardView.drawHierarchy(in: giftCardView.bounds, afterScreenUpdates: true)
        }
        snapView = UIImageView(image: image)
    }
    
    func tappedCheckoutButton(sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = .init(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                sender.transform = .identity
            }) { [unowned self] _ in
                self.flipCard()
            }
        }
    }
    
    func flipCard() {
        UIView.transition(from: self.containerView, to: self.snapView, duration: 1, options: .transitionFlipFromBottom) { [unowned self] _ in
            self.bottomThings.transform = .identity
            self.topThings.transform = .identity
            self.label1.transform = .identity
            self.label2.transform = .identity
            self.label3.transform = .identity
            self.label4.transform = .identity
            self.label5.transform = .identity
            self.buyButton.alpha = 1
            
            self.snapView.removeFromSuperview()
            self.giftCardView.addSubview(self.base)
            self.giftCardView.addSubview(self.containerView)
            self.center(view: self.base, in: self.giftCardView)
            self.center(view: self.containerView, in: self.giftCardView)
            self.giftWrapImageView.removeFromSuperview()
        }
    }
    
    func center(view child: UIView, in parent: UIView) {
        child.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        child.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
    }
    
    func configTopThings() {
        alphaView.addSubview(topThings)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == giftWrapImageView.layer.animation(forKey: "AnimateGiftWrap") {
            giftWrapImageView.layer.removeAnimation(forKey: "AnimateGiftWrap")
            slideTopThingsDown()
            slideInButtons()
            slideInLabels()
        }
    }
    
    func slideInLabels() {
        slideIn(label: label1, delay: 0)
        slideIn(label: label2, delay: 0.1)
        slideIn(label: label3, delay: 0.2)
        slideIn(label: label4, delay: 0.3)
        slideIn(label: label5, delay: 0.4)
    }
    
    private func slideIn(label: UIImageView, delay: Double) {
        UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseInOut, animations: {
            label.transform = CGAffineTransform(translationX: 20 - label.frame.origin.x, y: 0)
        }, completion: nil)
    }
    
    func slideInButtons() {
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.bottomThings.transform = CGAffineTransform(translationX: -263, y: 0)
            }, completion: nil)
    }
    
    func slideTopThingsDown() {
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            let downSize = CGAffineTransform(scaleX: 0.89, y: 0.89)
            let slideDown = CGAffineTransform(translationX: 0, y: 170)
            self.topThings.transform = downSize.concatenating(slideDown)
            }, completion: nil)
    }
    
    func tappedBuyButton(sender: UIButton) {
        snapView.removeFromSuperview()
        snapView.frame.origin = .zero
        sender.alpha = 0
        
        giftWrapImageView = UIImageView(image: #imageLiteral(resourceName: "Buy Button"))
        giftWrapImageView.image = UIImage(cgImage: imageArray.last!)
        giftWrapImageView.center = self.buyButton.center
        self.bottomThings.addSubview(giftWrapImageView)
        
        let anim = CAKeyframeAnimation(keyPath: "contents")
        anim.values = self.imageArray
        anim.duration = 1.5
        anim.repeatCount = 1
        anim.delegate = self
        anim.isRemovedOnCompletion = false
        giftWrapImageView.layer.add(anim, forKey: "AnimateGiftWrap")
    }
    
    func addImageToArray() {
        if let path = Bundle.main.resourcePath {
            let contents = try! FileManager.default.contentsOfDirectory(atPath: path)
            for item in contents {
                if item.hasPrefix("gifbutton") && item.hasSuffix(".png") {
                    imageArray.append(UIImage(named: item)!.cgImage!)
                }
            }
        }
    }
}

