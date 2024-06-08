//
//  WelcomeViewController.swift
//  RiPop
//
//  Created by Ebu Bekir Celik on 26.12.18.
//  Copyright © 2018 KeepEasy. All rights reserved.
//

import UIKit
import AVFoundation

class WelcomeViewController: UIViewController {
    let imageName = "logoripop"
    let screenSize = UIScreen.main.bounds
    var timer: Timer!
    var welcomeAudio = AVAudioPlayer()
    let login = UserDefaults.standard.bool(forKey: "firsttime")// to give the login/register alert one time out
    let recMute = UserDefaults.standard.bool(forKey: "mute") //for mute
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: Double(screenSize.width)/2-150, y: Double(screenSize.height)/2-150, width: 300.0, height: 300.0)
        view.addSubview(imageView)
        
        //sound effect - begin
        let sound = Bundle.main.path(forResource: "welcome", ofType: ".mp3")
        
        do
        {
            try welcomeAudio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
            
        catch{
            print(error)
        }
        
        if let muteokay = recMute as? Bool
        {
            if(muteokay)
            {
                welcomeAudio.play()
            }
        }
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(game), userInfo: nil, repeats: false)
    }
    
    @objc func game(){
//        if(!login)
//        {
//            //to open the menu
//            let menu = self.storyboard?.instantiateViewController(withIdentifier:  "log") as! LoginViewController
//            
//            self.present(menu, animated: true, completion: nil)
//        }
//        else
//        {
//
//        }
        //to open the menu
        let menu = self.storyboard?.instantiateViewController(withIdentifier:  "menu") as! SWRevealViewController

        self.present(menu, animated: true, completion: nil)
    }
}
