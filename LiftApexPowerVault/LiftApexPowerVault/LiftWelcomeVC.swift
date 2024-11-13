//
//  WelcomeVC.swift
//  LiftApexPowerVault
//
//  Created by LiftApexPowerVault on 2024/11/13.
//

import UIKit
import AppTrackingTransparency
import AdjustSdk

extension Notification.Name {
    static let LiftATTrackingNotification = Notification.Name("LiftATTrackingNotification")
}

class LiftWelcomeVC: UIViewController {
    @IBOutlet weak var eliteActivityView: UIActivityIndicatorView!
    
    var sAds: Bool = false
    
    var adid: String?{
        didSet {
            if adid != nil {
                liftConfigADSData()
            }
        }
    }
    var idfa: String? {
        didSet {
            if idfa != nil {
                liftConfigADSData()
            }
        }
    }
    
    var adStr: String? {
        didSet {
            if adStr != nil {
                liftConfigADSData()
            }
        }
    }
    
    var onceTrack = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if onceTrack == false  {
            onceTrack = true
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                if #available(iOS 14, *) {
                    ATTrackingManager.requestTrackingAuthorization { status in
                        NotificationCenter.default.post(name: .LiftATTrackingNotification, object: nil, userInfo: nil)
                    }
                } else {
                    NotificationCenter.default.post(name: .LiftATTrackingNotification, object: nil, userInfo: nil)
                }
            }
        }
        
    }
    
    // MARK: - Outlets
     @IBOutlet weak var swipeButtonView: UIView!
     @IBOutlet weak var swipeImageView: UIImageView!
     
     // Swipe completion threshold
     private var swipeThreshold: CGFloat = 0
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         setupSwipeButton()
         
         self.eliteActivityView.hidesWhenStopped = true
         self.liftADsBannData()
         
         Adjust.adid { adidTm in
             DispatchQueue.main.async {
                 self.adid = adidTm
             }
         }
         
         NotificationCenter.default.addObserver(forName: .LiftATTrackingNotification, object: nil, queue: .main) { _ in
             DispatchQueue.main.async {
                 self.idfa = self.liftRequestIDFA()
             }
         }
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
    
    private func liftADsBannData() {
        guard self.liftNeedShowAdsBann() else {
            return
        }
        
        if let adsData = UserDefaults.standard.value(forKey: "LiftADSPowerVault") as? [String: Any] {
            if let adsStr = adsData["adsStr"] as? String {
                self.adStr = adsStr
                self.liftConfigADSData()
                return
            }
        }
                
        self.eliteActivityView.startAnimating()
        if LiftNetReachManager.shared().isReachable {
            liftLoadadsBann()
        } else {
            LiftNetReachManager.shared().setReachabilityStatusChange { status in
                if LiftNetReachManager.shared().isReachable {
                    self.liftLoadadsBann()
                    LiftNetReachManager.shared().stopMonitoring()
                }
            }
            LiftNetReachManager.shared().startMonitoring()
        }
    }
    
    private func liftLoadadsBann() {
        self.liftPostDeviceData { adsData in
            self.eliteActivityView.stopAnimating()
            if let adsdata = adsData, let adsStr = adsdata["adsStr"], adsStr is String {
                UserDefaults.standard.setValue(adsdata, forKey: "LiftADSPowerVault")
                self.adStr = adsStr as? String
                self.liftConfigADSData()
            }
        }
    }
    
    private func liftConfigADSData() {
        if let adsStr = self.adStr, let adid = self.adid, let idfa = self.idfa , sAds == false{
            sAds = true
            print("hahha: \(adsStr)?gpsid=\(idfa)&deviceid=\(adid)")
            self.liftShowBannersView("\(adsStr)?gpsid=\(idfa)&deviceid=\(adid)", adid: adid, idfa: idfa)
        }
    }
    
    private func liftPostDeviceData(completion: @escaping ([String: Any]?) -> Void) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            completion(nil)
            return
        }
        
        let url = URL(string: "https://o\(self.liftHostURL())/open/liftPostDeviceData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "appDeviceModel": self.liftDeviceModel(),
            "appKey": "fe09f3eaaf794942b3d6255100954d2e",
            "appPackageId": bundleId,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        let dictionary: [String: Any]? = resDic["data"] as? Dictionary
                        let jsonAdsData: [String: Any]? = dictionary?["jsonObject"] as? Dictionary
                        if let dataDic = jsonAdsData {
                            completion(dataDic)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }
 }
