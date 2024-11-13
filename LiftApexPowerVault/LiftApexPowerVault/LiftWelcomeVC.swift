//
//  WelcomeVC.swift
//  LiftApexPowerVault
//
//  Created by jin fu on 2024/11/13.
//

import UIKit

class LiftWelcomeVC: UIViewController {

    // MARK: - Outlets
     @IBOutlet weak var swipeButtonView: UIView!
     @IBOutlet weak var swipeImageView: UIImageView!
     
     // Swipe completion threshold
     private var swipeThreshold: CGFloat = 0
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         setupSwipeButton()
     }
     
     // MARK: - Setup Swipe Button
     private func setupSwipeButton() {
         // Configure swipe button view
         //swipeButtonView.backgroundColor = .lightGray
         
         // Configure swipe image view (the draggable element)
         swipeImageView.image = UIImage(systemName: "arrow.right.circle.fill")
         swipeImageView.tintColor = .red
         swipeImageView.isUserInteractionEnabled = true
         
         // Add pan gesture recognizer to the image view
         let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
         swipeImageView.addGestureRecognizer(panGesture)
         
         // Set the swipe threshold to 80% of the swipeButtonView's width
         swipeThreshold = swipeButtonView.frame.width * 0.8
     }
     
     // MARK: - Pan Gesture Handler
     @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
         let translation = gesture.translation(in: swipeButtonView)
         
         // Limit the swipeImageView's movement within the swipeButtonView's width
         let newX = max(0, min(swipeImageView.frame.origin.x + translation.x, swipeButtonView.frame.width - swipeImageView.frame.width))
         
         // Update swipeImageView's position
         swipeImageView.frame.origin.x = newX
         
         // Reset the translation to avoid compounding
         gesture.setTranslation(.zero, in: swipeButtonView)
         
         // Check if swipe has reached the threshold
         if gesture.state == .ended {
             print(swipeImageView.frame.origin.x + 28)
             print(swipeThreshold)
             if (swipeImageView.frame.origin.x + 28) >= swipeThreshold {
              
                 // Swipe completed successfully
                 performSwipeAction()
                 
                 // Reset swipeImageView's position to the start
                 UIView.animate(withDuration: 0.3) {
                     self.swipeImageView.frame.origin.x = 0
                 }
             } else {
                 // Swipe not completed, reset position
                 UIView.animate(withDuration: 0.3) {
                     self.swipeImageView.frame.origin.x = 0
                 }
             }
         }
     }
     
     // MARK: - Perform Action on Successful Swipe
     private func performSwipeAction() {
         print("Swipe action completed!")
         // Add your action code here
         if let vc = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? LiftHomeVC {
             navigationController?.pushViewController(vc, animated: true)
         }
     }
 }
