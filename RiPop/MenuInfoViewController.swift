//
//  MenuInfoViewController.swift
//  RiPop
//
//  Created by Ebu Bekir Celik on 27.12.18.
//  Copyright © 2018 KeepEasy. All rights reserved.
//

import UIKit
import AVFoundation

class MenuInfoViewController: UIViewController {

    @IBOutlet var back: UIButton!
    var infotext = UITextView()
    var subtitle = UITextView()
    let screenSize = UIScreen.main.bounds
    var tapAudio = AVAudioPlayer()
    var informationtext = String()
    var informationsubtitle = String()
    let recMute = UserDefaults.standard.bool(forKey: "mute")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let locale = NSLocale.current.languageCode
        
        if(locale! == "de")
        {
            informationtext = "informationtext".localizabelString(loc: "de")
            informationsubtitle = "informationsubtitle".localizabelString(loc: "de")
        }
        else if(locale! == "en")
        {
            informationtext = "informationtext".localizabelString(loc: "en")
            informationsubtitle = "informationsubtitle".localizabelString(loc: "en")
        }
        else if(locale! == "tr")
        {
            informationtext = "informationtext".localizabelString(loc: "tr")
            informationsubtitle = "informationsubtitle".localizabelString(loc: "tr")
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
        
        infotext.frame = CGRect(x: screenSize.width/2-150, y: screenSize.height/2-150, width: 300, height: 350)
        infotext.backgroundColor = .clear
        infotext.textColor = .white
        infotext.text = informationtext
        infotext.font = UIFont(name: (infotext.font?.fontName)!, size: 20)
        infotext.isEditable = false
        infotext.isSelectable = false
        view.addSubview(infotext)
        
        subtitle.frame = CGRect(x: screenSize.width/2-150, y: screenSize.height/2-250, width: 300, height: 60)
        subtitle.backgroundColor = .clear
        subtitle.textColor = .green
        subtitle.textAlignment = .center
        subtitle.text = informationsubtitle
        subtitle.font = UIFont(name: (subtitle.font?.fontName)!, size: 28)
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
