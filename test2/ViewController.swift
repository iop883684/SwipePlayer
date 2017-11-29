//
//  ViewController.swift
//  test2
//
//  Created by Dustin Doan on 11/23/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

import UIKit
import SnapKit
import YetAnotherAnimationLibrary


class ViewController: UIViewController {
    
    var playerVC:PlayerViewController!
    var botConstrain:Constraint!
    @IBOutlet var tabbarView:UITabBar!

    var playerCenter:CGPoint! = .zero
    var viewCenter:CGPoint! = .zero
    var tabbarDefaultCenter:CGPoint = .zero
    var tabbarEndCenter:CGPoint = .zero
    
    var gestureSimultaneously = false
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        playerVC = self.storyboard?.instantiateViewController(withIdentifier: "playerVC") as! PlayerViewController
        playerVC.delegate = self
        view.insertSubview(playerVC.view, belowSubview: tabbarView)
        
        let screenHeight = UIScreen.main.bounds.size.height
        playerVC.view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            botConstrain = make.bottom.equalTo(screenHeight - 50).constraint.update(priority: 200)
            make.height.equalTo(screenHeight + 50)
        }
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(pan(gr:)))
        gesture.delegate = self
        playerVC.view.addGestureRecognizer(gesture)
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if playerCenter == .zero {
            
            playerCenter = playerVC.view.center
            var poin = view.center
            poin.y -= 25
            viewCenter = poin
            
            print("player center", playerVC.view.center)
            print("view center", view.center)
            
            tabbarDefaultCenter = tabbarView.center
            tabbarEndCenter = tabbarDefaultCenter
            tabbarEndCenter.y += 50
            
        }
        
       
    }
    
    var beginPosition: CGPoint?
    @objc func pan(gr: UIPanGestureRecognizer) {
        switch gr.state {
        case .began:
            beginPosition = playerVC.view.center
            fallthrough
        case .changed:
            var newPoint = gr.translation(in: view) + beginPosition!
            
            if newPoint.y < viewCenter.y || newPoint.y > playerCenter.y {
                return
            }
            
            newPoint.x = (beginPosition?.x)!
            playerVC.view.yaal.center.setTo(newPoint)
            
            let tabbarNewPoint = getLocationForTabbar(poin: newPoint)
            tabbarView.yaal.center.setTo(tabbarNewPoint)
            
        default:
            var ve = gr.velocity(in: nil)
            ve.x = 0
//            print("ver", ve.x = 0, "-", ve.y)
//            playerVC.view.yaal.center.decay(initialVelocity:ve, damping: 5)
            if ve.y > 0{
                playerVC.view.yaal.center.animateTo(playerCenter)
                tabbarView.yaal.center.animateTo(tabbarDefaultCenter)
            } else {
                playerVC.view.yaal.center.animateTo(viewCenter)
                tabbarView.yaal.center.animateTo(tabbarEndCenter)
            }
            
        }
    }
    
    func getLocationForTabbar(poin:CGPoint)->CGPoint{
        
        print("point", poin.y)
        
        let playerTravelDistant = playerCenter.y - viewCenter.y
        let tabbarTravelDistant = tabbarEndCenter.y - tabbarDefaultCenter.y
        
        let currentY = tabbarEndCenter.y - (poin.y-viewCenter.y) / playerTravelDistant * tabbarTravelDistant
        
        print(currentY)
        
        return CGPoint(x: tabbarDefaultCenter.x, y: currentY)
    }
    
}

extension ViewController: UIGestureRecognizerDelegate{
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureSimultaneously
    }
    
}

extension ViewController: PlayerDelegate{
    
    func didTapOnPlayer() {
        playerVC.view.yaal.center.animateTo(viewCenter)
        tabbarView.yaal.center.animateTo(tabbarEndCenter)
    }
    
    func scrollStatus(isTop: Bool) {
        
        gestureSimultaneously = isTop
        
    }
    
}

extension CGPoint {
    var magnitude: CGFloat {
        return hypot(x, y)
    }
}
func + (l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x + r.x, y: l.y + r.y)
}

extension CGFloat {
    func clamp(_ a: CGFloat, b: CGFloat) -> CGFloat {
        return CGFloat.minimum(CGFloat.maximum(self, a), b)
    }
}

