// HudView.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2016 apegroup
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

class HudView: UIView {

    @IBOutlet weak var hudMessageView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var iconImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hudHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hudWidthConstraint: NSLayoutConstraint!
    
    var isActivityIndicatorSpinnning: Bool {

        get {
            return self.loadingActivityIndicator.isAnimating()
        }

    }
    
    var isActiveTimer: Bool = false {
        willSet {
            if !newValue {
                timer.invalidate()
            }
        }
    }

    private var isAnimating: Bool = false
    private var timer = NSTimer()
    private var loadingMessagesHandler: LoadingMessagesHandler!
    private var blurEffectView: UIView?
}


extension HudView {

    static func create() -> HudView {

        let view: HudView = UIView.loadFromNibNamed("HudView", bundle: NSBundle(forClass: HudView.self), cached: true)!
        
        // Colors
        view.informationLabel.textColor = APESuperHUD.appearance.textColor
        view.hudMessageView.backgroundColor = APESuperHUD.appearance.foregroundColor
        view.backgroundColor = APESuperHUD.appearance.backgroundColor
        view.iconImageView.tintColor = APESuperHUD.appearance.iconColor
        view.loadingActivityIndicator.color = APESuperHUD.appearance.loadingActivityIndicatorColor

        // Corner radius
        view.hudMessageView.layer.cornerRadius = CGFloat(APESuperHUD.appearance.cornerRadius)
        
        // Shadow
        if APESuperHUD.appearance.shadow {
            view.hudMessageView.layer.shadowColor = UIColor.blackColor().CGColor
            view.hudMessageView.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.hudMessageView.layer.shadowRadius = 6.0
            view.hudMessageView.layer.shadowOpacity = 0.15
        }
        
        // Font
        let font = UIFont(name: APESuperHUD.appearance.fontName, size: APESuperHUD.appearance.fontSize)
        view.informationLabel.font = font
        
        return view
    }
    
    func deviceOrientationDidChange() {
        frame = (superview?.bounds)!
        blurEffectView?.frame = (superview?.bounds)!

        layoutIfNeeded()
    }

    func removeHud(animated animated: Bool, onDone: (Void -> Void)?) {

        NSNotificationCenter.defaultCenter().removeObserver(self)
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
        timer.invalidate()
        
        if animated {
            animateOutHud(completion: { [weak self] _ in
                
                self?.blurEffectView?.removeFromSuperview()
                self?.removeFromSuperview()
                
                onDone?()

            })

        } else {
            
            self.blurEffectView?.removeFromSuperview()
            self.removeFromSuperview()
            
            onDone?()

        }

    }
    
    func showMessages(messages: [String]) {
        loadingMessagesHandler = LoadingMessagesHandler(messages: messages)
        showMessages()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: Selector("showMessages"), userInfo: nil, repeats: true)
    }
    
    func showMessages() {
        let message = loadingMessagesHandler.firstMessage()
        if isActiveTimer {
            hideViewsAnimated(views: [informationLabel], completion: { [weak self] in
                self?.showLoadingActivityIndicator(text: message, completion: nil)
            })
        }
    }
    
    func showFunnyMessages(languageType: LanguageType) {
        loadingMessagesHandler = LoadingMessagesHandler(languageType: languageType)
        showFunnyMessages()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: Selector("showFunnyMessages"), userInfo: nil, repeats: true)
    }
    
    func showFunnyMessages() {
        let funnyMessage = loadingMessagesHandler.randomMessage()
        if isActiveTimer {
            hideViewsAnimated(views: [informationLabel], completion: { [weak self] in
                self?.showLoadingActivityIndicator(text: funnyMessage, completion: nil)
            })
        }
    }

    func showLoadingActivityIndicator(text text: String?, completion: (() -> Void)?) {

        iconImageView.alpha = 0.0
        informationLabel.text = text ?? ""

        loadingActivityIndicator.startAnimating()

        showViewsAnimated(views: [loadingActivityIndicator, informationLabel], completion: { _ in

            completion?()

        })

    }

    func hideLoadingActivityIndicator(completion completion: (() -> Void)?) {

        hideViewsAnimated(views: [loadingActivityIndicator, informationLabel], completion: { [weak self] _ in

            self?.loadingActivityIndicator.stopAnimating()

            completion?()

        })

    }

    func showMessage(message message: String?, icon: UIImage?, completion: (() -> Void)?) {

        informationLabel.text = message

        if icon != nil {
            alpha = 1.0
            iconImageView.image = icon
            loadingActivityIndicator.alpha = 0
            loadingActivityIndicator.stopAnimating()
        }

        showViewsAnimated(views: [informationLabel, iconImageView], completion: { _ in

            completion?()

        })

    }
}


// MARK: - Lifecycle

extension HudView {

    override internal func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if let bounds = newSuperview?.bounds {
            frame = bounds
            
            if addBlurEffectView() != nil {
                backgroundColor = UIColor.clearColor()
                blurEffectView = addBlurEffectView()
                insertSubview(blurEffectView!, atIndex: 0)
            }

            UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
            NSNotificationCenter.defaultCenter().removeObserver(self)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("deviceOrientationDidChange"), name: UIDeviceOrientationDidChangeNotification, object: nil)
            
            // HUD Size
            if APESuperHUD.appearance.hudSquareSize < frame.width && APESuperHUD.appearance.hudSquareSize < frame.height {
                hudWidthConstraint.constant = APESuperHUD.appearance.hudSquareSize
                hudHeightConstraint.constant = APESuperHUD.appearance.hudSquareSize
            
            } else {
                let size = frame.width <= frame.height ? frame.width : frame.height
                hudWidthConstraint.constant = size
                hudHeightConstraint.constant = size
            }
            
            // Icon size
            iconImageWidthConstraint.constant = APESuperHUD.appearance.iconWidth
            iconImageHeightConstraint.constant = APESuperHUD.appearance.iconHeight
        }

    }

    override internal func didMoveToSuperview() {
        super.didMoveToSuperview()

        setupDefaultState()

        animateInHud({ _ in

        })

    }
}


// MARK: - Setup

extension HudView {

    private func setupDefaultState() {

        alpha = 0.0
        hudMessageView.alpha = 0.0
        informationLabel.alpha = 0.0
        iconImageView.alpha = 0.0
        loadingActivityIndicator.alpha = 0.0
        loadingActivityIndicator.stopAnimating()

        layoutIfNeeded()

    }
    
    private func addBlurEffectView() -> UIView? {
        
        var blurEffect: UIBlurEffect?
   
        switch APESuperHUD.appearance.backgroundBlurEffect {
            
        case .Dark:
            blurEffect =  UIBlurEffect(style: UIBlurEffectStyle.Dark)
            
        case .Light:
            blurEffect =  UIBlurEffect(style: UIBlurEffectStyle.Light)
            
        case .ExtraLight:
            blurEffect =  UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            
        case .None:
            
          return nil
            
        }
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        
        return blurEffectView
        
    }

}


// MARK: - User Interactions
extension HudView {
    
    @IBAction func tapGestureRecognized(sender: AnyObject) {
        
        if APESuperHUD.appearance.cancelableOnTouch {
            removeHud(animated: true, onDone: nil)
        }
        
    }
    
}


// MARK: - Animations

extension HudView {

    private func animateInHud(completion: () -> Void ) {

        hudMessageView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        layoutIfNeeded()

        UIView.animateWithDuration(APESuperHUD.appearance.animateInTime, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { [weak self] _ in

            self?.hudMessageView.alpha = 1.0
            self?.alpha = 1.0
            self?.hudMessageView.transform = CGAffineTransformMakeScale(1.0, 1.0)

            self?.layoutIfNeeded()

            }, completion: { _ in

                completion()
        })

    }

    private func animateOutHud(completion completion: () -> Void) {

        let delay: NSTimeInterval = isAnimating ? (APESuperHUD.appearance.animateInTime + 0.1) : 0

        isAnimating = true

        UIView.animateWithDuration(APESuperHUD.appearance.animateOutTime, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: { [weak self] _ in

            self?.alpha = 0.0

            }, completion: { [weak self] _ in

                self?.isAnimating = false
                completion()

            })

    }

    /**
     Animates in a array of views.
     
     - parameter views: the array of views to animate in
     - parameter completion: The completion block that will be trigger when the animation of views are finished
     
    */
    private func showViewsAnimated(views views: [UIView], completion: () -> Void ) {

        let delay: NSTimeInterval = isAnimating ? APESuperHUD.appearance.animateInTime : 0

        isAnimating = true

        UIView.animateWithDuration(APESuperHUD.appearance.animateOutTime, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {

            for view in views {
                view.alpha = 1.0
            }

            }, completion: { [weak self] _ in

                self?.isAnimating = false
                completion()

            })

    }

    /**
     Animates out a array of views.
     
     - parameter views: the array of views to animate ot
     - parameter completion: The completion block that will be trigger when the animation of views are finished
     
    */
    private func hideViewsAnimated(views views: [UIView], completion: () -> Void ) {

        let delay: NSTimeInterval = isAnimating ? APESuperHUD.appearance.animateInTime : 0

        runWithDelay(delay + 0.1, closure: { [weak self] in

            self?.isAnimating = true

            UIView.animateWithDuration(APESuperHUD.appearance.animateOutTime, animations: {

                for view in views {
                    view.alpha = 0.0
                }

                }, completion: { [weak self] _ in

                    self?.isAnimating = false
                    completion()

            })

        })

    }

}
