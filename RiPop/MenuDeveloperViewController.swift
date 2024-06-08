//
//  MenuDeveloperViewController.swift
//  RiPop
//
//  Created by Ebu Bekir Celik on 28.12.18.
//  Copyright © 2018 KeepEasy. All rights reserved.
//

import UIKit
import AVFoundation

class MenuDeveloperViewController: UIViewController {

    var infotext = UITextView()
    var subtitle = UITextView()
    @IBOutlet var back: UIButton!
    @IBOutlet var instagram: UIButton!
    @IBOutlet var instagrambtn: UIButton!
    var contact = String()
    var contactsubtitle = String()
    var tapAudio = AVAudioPlayer()
    let screenSize = UIScreen.main.bounds
    let recMute = UserDefaults.standard.bool(forKey: "mute")
    
    @IBAction func openinstagram(_ sender: Any) {
        if let muteOK = recMute as? Bool
        {
            if(muteOK)
            {
                tapAudio.play()
            }
        }
        let instagramHooks = "instagram://user?username=ebu.celik"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "https://www.instagram.com/ebu.celik/?hl=de")! as URL)
        }
    }
    @IBAction func openinstagrambtn(_ sender: Any) {
        if let muteOK = recMute as? Bool
        {
            if(muteOK)
            {
                tapAudio.play()
            }
        }
        let instagramHooks = "instagram://user?username=ebu.celik"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "https://www.instagram.com/ebu.celik/?hl=de")! as URL)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let locale = NSLocale.current.languageCode
        
        if(locale! == "de")
        {
            contact = "contact".localizabelString(loc: "de")
            contactsubtitle = "contactsubtitle".localizabelString(loc: "de")
        }
        else if(locale! == "en")
        {
            contact = "contact".localizabelString(loc: "en")
            contactsubtitle = "contactsubtitle".localizabelString(loc: "en")
        }
        else if(locale! == "tr")
        {
            contact = "contact".localizabelString(loc: "tr")
            contactsubtitle = "contactsubtitle".localizabelString(loc: "tr")
        }
        
        //sound effect - begin
        let sound = Bundle.main.path(forResource: "tap", ofType: ".mp3")
        
        do
        {
            try tapAudio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
            
        catch{
            print(error)
        }
        //sound effect - end
        
        infotext.frame = CGRect(x: screenSize.width/2-150, y: screenSize.height/2-50, width: 350, height: 300)
        infotext.backgroundColor = .black
        infotext.textColor = .white
        infotext.text = contact + "\n\nCelik Ebu Bekir\nebucelik1@hotmail.com\nCopyright © 2018 Celik Ebu Bekir"
//        infotext.font = UIFont(name: (infotext.font?.fontName)!, size: 20)
        infotext.isEditable = false
        infotext.isSelectable = false
        view.addSubview(infotext)
        
        subtitle.frame = CGRect(x: screenSize.width/2-150, y: screenSize.height/2-250, width: 300, height: 60)
        subtitle.backgroundColor = .black
        subtitle.textColor = .green
        subtitle.textAlignment = .center
        subtitle.text = contactsubtitle
//        subtitle.font = UIFont(name: (infotext.font?.fontName)!, size: 28)
        subtitle.isEditable = false
        subtitle.isSelectable = false
        view.addSubview(subtitle)
        
        back.frame = CGRect(x: Double(15), y: Double(screenSize.height)-50, width: 70, height: 30)
        back.layer.cornerRadius = 10
        back.layer.borderWidth = 1
        back.layer.borderColor = UIColor.white.cgColor
        back.layer.backgroundColor = UIColor.black.cgColor
        back.layer.isHidden = false
        back.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(back)
        
        let image = UIImage(named: "instagram") as UIImage?
        instagram.frame = CGRect(x: Double(screenSize.width/2-145), y: Double(screenSize.height)/2+100, width: 35, height: 35)
        instagram.layer.cornerRadius = 10
        instagram.tintColor = UIColor.white
        instagram.setImage(image, for: .normal)
        instagram.layer.backgroundColor = UIColor.clear.cgColor
        instagram.layer.isHidden = false
        instagram.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(instagram)
        
        instagrambtn.frame = CGRect(x: Double(screenSize.width/2-95), y: Double(screenSize.height)/2+100, width: 250, height: 35)
        instagrambtn.layer.cornerRadius = 10
        instagrambtn.layer.borderWidth = 1
        instagrambtn.layer.borderColor = UIColor.white.cgColor
        instagrambtn.layer.backgroundColor = UIColor.black.cgColor
        instagrambtn.layer.isHidden = false
        instagrambtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(instagrambtn)
    }
    @IBAction func onback(_ sender: Any) {
        if let muteOK = recMute as? Bool
        {
            if(muteOK)
            {
                tapAudio.play()
            }
        }
    }
}
