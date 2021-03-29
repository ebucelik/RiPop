//
//  MenuViewController.swift
//  RiPop
//
//  Created by Ebu Bekir Celik on 27.12.18.
//  Copyright © 2018 KeepEasy. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class MenuViewController: UIViewController {

    let imageName = "logoripop"
    let rec = UserDefaults.standard.object(forKey: "key")
    let recMute = UserDefaults.standard.bool(forKey: "mute")
    let user = UserDefaults.standard.object(forKey: "username")
    var record = UITextView()
    @IBOutlet var play: UIButton!
    @IBOutlet var menubtn: UIBarButtonItem!
    let screenSize = UIScreen.main.bounds
    var tapAudio = AVAudioPlayer()
    var userField: UITextField?
    var passField: UITextField?
    var muteokay = true
    @IBOutlet var mute: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        
        let ref = Database.database().reference() //Database reference
        
        let locale = NSLocale.current.languageCode //get the current phone language de, en, tr ...
        
        play.frame = CGRect(x: Double(screenSize.width)/2-100, y: Double(screenSize.height)/2+100, width: 200, height: 40)
        play.layer.cornerRadius = 10
        play.layer.borderWidth = 1
        play.layer.borderColor = UIColor.white.cgColor
        play.layer.backgroundColor = UIColor.black.cgColor
        play.layer.isHidden = false
        view.addSubview(play)
        
        record.frame = CGRect(x: Double(screenSize.width)/2-100, y: Double(screenSize.height)-100, width: 200, height: 40)
        record.backgroundColor = .black
        record.textColor = .white
        record.textAlignment = .center
        record.layer.cornerRadius = 10
        record.layer.borderWidth = 1
        record.layer.borderColor = UIColor.white.cgColor
        if let recordName = rec as? String
        {
            if(locale! == "de")
            {
                record.text = "Highscore".localizabelString(loc: "de") + recordName
                //record save to database
                if let loginalert = user as? String
                {
                    if(loginalert != "")
                    {
                        ref.child("Records/" + (loginalert) + "/score").setValue(Int(recordName))
                        ref.child("Records/" + (loginalert) + "/name").setValue((loginalert))
                    }
                }
            }
            else if(locale! == "en")
            {
                record.text = "Highscore".localizabelString(loc: "en") + recordName
                //record save to database
                if let loginalert = user as? String
                {
                    if(loginalert != "")
                    {
                        ref.child("Records/" + (loginalert) + "/score").setValue(Int(recordName))
                        ref.child("Records/" + (loginalert) + "/name").setValue((loginalert))
                    }
                }
            }
            else if(locale! == "tr")
            {
                record.text = "Highscore".localizabelString(loc: "tr") + recordName
                //record save to database
                if let loginalert = user as? String
                {
                    if(loginalert != "")
                    {
                        ref.child("Records/" + (loginalert) + "/score").setValue(Int(recordName))
                        ref.child("Records/" + (loginalert) + "/name").setValue((loginalert))
                    }
                }
            }
        }
        else if(rec == nil){
            if(locale! == "de")
            {
                record.text = "Highscore".localizabelString(loc: "de") + "0"
            }
            else if(locale! == "en")
            {
                record.text = "Highscore".localizabelString(loc: "de") + "0"
            }
            else if(locale! == "tr")
            {
                record.text = "Highscore".localizabelString(loc: "de") + "0"
            }
        }
        record.font = UIFont(name: (record.font?.fontName)!, size: 20)
        record.isEditable = false
        record.isSelectable = false
        view.addSubview(record)
        
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: Double(screenSize.width)/2-100, y: Double(screenSize.height)/2-200, width: 200.0, height: 200.0)
        view.addSubview(imageView)
        
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
        
        sidemenu()
        
        if let muteOK = recMute as? Bool
        {
            if(muteOK)
            {
                mute.image = UIImage(named: "notmute.png")
                muteokay = false
            }
            else
            {
                mute.image = UIImage(named: "mute.png")
                muteokay = true
            }
        }
    }
    
    func userField(textfield: UITextField)
    {
        userField = textfield
        userField?.placeholder = "Username"
    }
    
    func passField(textfield: UITextField)
    {
        passField = textfield
        passField?.placeholder = "Password"
        passField?.isSecureTextEntry = true
    }
    
    @IBAction func ontapbtn(_ sender: Any) {
        if let muteOK = recMute as? Bool
        {
            if(muteOK)
            {
                tapAudio.play()
            }
        }
    }
    
    func sidemenu()
    {
        //to call the menu bar
        if(revealViewController() != nil)
        {
            menubtn.target = revealViewController()
            menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController()?.rearViewRevealWidth = screenSize.width-100
            
            view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        }
    }
    
    @IBAction func onclickmute(_ sender: Any) {
        if(muteokay)
        {
            mute.image = UIImage(named: "notmute.png")
            
            UserDefaults.standard.set(true, forKey: "mute")
            
            muteokay = false
        }
        else
        {
            mute.image = UIImage(named: "mute.png")
            
            UserDefaults.standard.set(false, forKey: "mute")
            
            muteokay = true
        }
    }
}

//to implement the strings from other languages
extension String{
    func localizabelString(loc: String) -> String{
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
