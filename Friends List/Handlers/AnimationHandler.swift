//
//  AnimationHandler.swift
//  Friends List
//
//  Created by Nigell Dennis on 9/30/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//
import UIKit

enum State {
    case closed
    case open
}
 
extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

extension MainViewController {
    func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.cardViewContraint.constant = 180
                self.mainProfileView.alpha = 1.0
                self.profileButton.alpha = 0.0
                self.searchView.alpha = 0.0
                self.titleLabel.alpha = 0.3
                self.tableView.alpha = 0.3
                self.collectionView.alpha = 0.3
            case .closed:
                self.cardViewContraint.constant = 18
                self.mainProfileView.alpha = 0.0
                self.profileButton.alpha = 1.0
                self.searchView.alpha = 1.0
                self.titleLabel.alpha = 1.0
                self.tableView.alpha = 1.0
                self.collectionView.alpha = 1.0
            }
            self.view.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            default:
                break
            }
            
            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.cardViewContraint.constant = 180
                self.mainProfileView.alpha = 1.0
                self.tableView.isUserInteractionEnabled = false
                self.collectionView.isUserInteractionEnabled = false
            case .closed:
                self.cardViewContraint.constant = 18
                self.mainProfileView.alpha = 0.0
                self.tableView.isUserInteractionEnabled = true
                self.collectionView.isUserInteractionEnabled = true
            }
            
            self.runningAnimators.removeAll()
            
        }
        transitionAnimator.startAnimation()
        runningAnimators.append(transitionAnimator)
        
    }
    
    @objc func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 0.5)
            
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = recognizer.translation(in: cardView)
            var fraction = translation.y / popupOffset // 1/2 change tranlastion to negative to go opposite way
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let yVelocity = -recognizer.velocity(in: cardView).y // 2/2 change recognizer to postive to go opposite way
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
}

class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
    
}
