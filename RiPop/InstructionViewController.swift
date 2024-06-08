//
//  InstructionViewController.swift
//  RiPop
//
//  Created by Ebu Bekir Celik on 28.12.18.
//  Copyright © 2018 KeepEasy. All rights reserved.
//

import UIKit
import AVFoundation

class InstructionViewController: UIViewController {

    @IBOutlet var back: UIButton!
    @IBOutlet var nextPic: UIButton!
    let screenSize = UIScreen.main.bounds
    var helpText1 = String()
    var helpText2 = String()
    var helpText3 = String()
    var helpText4 = String()
    var phoneheight = 0.0
    var phonewidth = 0.0
    var phoneheighthalf = 0.0
    var phonewidthhalf = 0.0
    var helptextheight = 0.0
    let image1 = "first.PNG"
    let image2 = "second.PNG"
    let image3 = "third.PNG"
    let image4 = "fourth.PNG"
    var img1 = UIImage()
    var imageView1 = UIImageView()
    var img2 = UIImage()
    var imageView2 = UIImageView()
    var img3 = UIImage()
    var imageView3 = UIImageView()
    var img4 = UIImage()
    var imageView4 = UIImageView()
    var imageHelpText = UITextView()
    var tapAudio = AVAudioPlayer()
    var nextPicCnt = 0
    let recMute = UserDefaults.standard.bool(forKey: "mute")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detectDevices()
        
        let locale = NSLocale.current.languageCode
        
        if(locale! == "de")
        {
            helpText1 = "first".localizabelString(loc: "de")
            helpText2 = "second".localizabelString(loc: "de")
            helpText3 = "third".localizabelString(loc: "de")
            helpText4 = "fourth".localizabelString(loc: "de")
        }
        else if(locale! == "en")
        {
            helpText1 = "first".localizabelString(loc: "en")
            helpText2 = "second".localizabelString(loc: "en")
            helpText3 = "third".localizabelString(loc: "en")
            helpText4 = "fourth".localizabelString(loc: "en")
        }
        else if(locale! == "tr")
        {
            helpText1 = "first".localizabelString(loc: "tr")
            helpText2 = "second".localizabelString(loc: "tr")
            helpText3 = "third".localizabelString(loc: "tr")
            helpText4 = "fourth".localizabelString(loc: "tr")
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
        
        back.frame = CGRect(x: Double(15), y: Double(screenSize.height)-50, width: 70, height: 30)
        back.layer.cornerRadius = 10
        back.layer.borderWidth = 1
        back.layer.borderColor = UIColor.white.cgColor
        back.layer.backgroundColor = UIColor.black.cgColor
        back.layer.isHidden = true
        back.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(back)
        
        nextPic.frame = CGRect(x: Double(screenSize.width)-85, y: Double(screenSize.height)-50, width: 70, height: 30)
        nextPic.layer.cornerRadius = 10
        nextPic.layer.borderWidth = 1
        nextPic.layer.borderColor = UIColor.white.cgColor
        nextPic.layer.backgroundColor = UIColor.black.cgColor
        nextPic.layer.isHidden = false
        nextPic.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(nextPic)
        
        img1 = UIImage(named: image1)!
        imageView1 = UIImageView(image: img1)
        imageView1.frame = CGRect(x: Double(screenSize.width)/2-phonewidthhalf, y: Double(screenSize.height)/2-phoneheighthalf, width: phonewidth, height: phoneheight)
        imageView1.isHidden = false
        view.addSubview(imageView1)
        
        img2 = UIImage(named: image2)!
        imageView2 = UIImageView(image: img2)
        imageView2.frame = CGRect(x: Double(screenSize.width)/2-phonewidthhalf, y: Double(screenSize.height)/2-phoneheighthalf, width: phonewidth, height: phoneheight)
        imageView2.isHidden = true
        view.addSubview(imageView2)
        
        img3 = UIImage(named: image3)!
        imageView3 = UIImageView(image: img3)
        imageView3.frame = CGRect(x: Double(screenSize.width)/2-phonewidthhalf, y: Double(screenSize.height)/2-phoneheighthalf, width: phonewidth, height: phoneheight)
        imageView3.isHidden = true
        view.addSubview(imageView3)
        
        img4 = UIImage(named: image4)!
        imageView4 = UIImageView(image: img4)
        imageView4.frame = CGRect(x: Double(screenSize.width)/2-phonewidthhalf, y: Double(screenSize.height)/2-phoneheighthalf, width: phonewidth, height: phoneheight)
        imageView4.isHidden = true
        view.addSubview(imageView4)
        
        imageHelpText.frame = CGRect(x: Double(screenSize.width)/2-125, y: Double(screenSize.height)/2+helptextheight, width: 250, height: 60)
        imageHelpText.backgroundColor = .clear
        imageHelpText.textColor = .white
        imageHelpText.text = helpText1
//        imageHelpText.font = UIFont(name: (imageHelpText.font?.fontName)!, size: 16)
        imageHelpText.isEditable = false
        imageHelpText.isSelectable = false
        view.addSubview(imageHelpText)
    }

    @IBAction func changePic(_ sender: Any) {
        nextPicCnt += 1
        
        if let muteOK = recMute as? Bool
        {
            if(muteOK)
            {
                tapAudio.play()
            }
        }
        
        switch nextPicCnt {
        case 1:
            imageView1.isHidden = true
            imageView2.isHidden = false
            imageHelpText.text = helpText2
        case 2:
            imageView2.isHidden = true
            imageView3.isHidden = false
            imageHelpText.text = helpText3
        case 3:
            imageView3.isHidden = true
            imageView4.isHidden = false
            nextPic.isHidden = true
            back.isHidden = false
            imageHelpText.text = helpText4
        default:
            imageView3.isHidden = true
            imageView4.isHidden = false
            nextPic.isHidden = true
            back.isHidden = false
            imageHelpText.text = helpText4
        }
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
    
    func detectDevices()
    {
        if(UIDevice().userInterfaceIdiom == .phone)
        {
            switch UIScreen.main.nativeBounds.height{
            case 1136:
                phoneheight = 400.0
                phonewidth = 250.0
                phoneheighthalf = 250.0
                phonewidthhalf = 125.0
                helptextheight = 150.0
            case 1334:
                phoneheight = 500.0
                phonewidth = 350.0
                phoneheighthalf = 300.0
                phonewidthhalf = 175.0
                helptextheight = 200.0
            case 1920, 2208:
                phoneheight = 600.0
                phonewidth = 350.0
                phoneheighthalf = 350.0
                phonewidthhalf = 175.0
                helptextheight = 250.0
            case 1792:
                phoneheight = 600.0
                phonewidth = 350.0
                phoneheighthalf = 350.0
                phonewidthhalf = 175.0
                helptextheight = 250.0
            case 2436:
                phoneheight = 600.0
                phonewidth = 350.0
                phoneheighthalf = 350.0
                phonewidthhalf = 175.0
                helptextheight = 250.0
            case 2688:
                phoneheight = 650.0
                phonewidth = 350.0
                phoneheighthalf = 400.0
                phonewidthhalf = 175.0
                helptextheight = 300.0
            default:
                phoneheight = 400.0
                phonewidth = 250.0
                phoneheighthalf = 250.0
                phonewidthhalf = 125.0
                helptextheight = 150.0
            }
        }
        else if(UIDevice().userInterfaceIdiom == .pad)
        {
            switch UIScreen.main.nativeBounds.height{
            case 2048:
                phoneheight = 700.0
                phonewidth = 600.0
                phoneheighthalf = 400.0
                phonewidthhalf = 300.0
                helptextheight = 350.0
            case 2224:
                phoneheight = 900.0
                phonewidth = 700.0
                phoneheighthalf = 500.0
                phonewidthhalf = 350.0
                helptextheight = 400.0
            case 2732:
                phoneheight = 1100.0
                phonewidth = 800.0
                phoneheighthalf = 650.0
                phonewidthhalf = 400.0
                helptextheight = 500.0
            default:
                phoneheight = 700.0
                phonewidth = 600.0
                phoneheighthalf = 400.0
                phonewidthhalf = 300.0
                helptextheight = 350.0
            }
        }
    }
}
