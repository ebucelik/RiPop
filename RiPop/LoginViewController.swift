//
//  LoginViewController.swift
//  RiPop
//
//  Created by Ebu Bekir Celik on 03.01.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    var tapAudio = AVAudioPlayer()
    
    let locale = NSLocale.current.languageCode //get the current phone language de, en, tr ...
    
    @IBOutlet var login: UIButton!
    @IBOutlet var username: UITextField!
    
    var userPhoneID = UIDevice.current.identifierForVendor?.uuidString
    
    var first = ""
    var second = ""
    var third = ""
    var fourth = ""
    
    let rec = UserDefaults.standard.object(forKey: "key")
    let user = UserDefaults.standard.object(forKey: "username")
    
    let ref = Database.database().reference() //Database
    let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dismiss Keyboard begin
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        //Dismiss Keyboard end
        
        username.frame = CGRect(x: Double(screenSize.width/2-100), y: Double(screenSize.height/2-50), width: 200, height: 30)
        username.layer.cornerRadius = 10
        username.layer.borderWidth = 1
        username.layer.borderColor = UIColor.white.cgColor
        username.textColor = UIColor.black
        username.layer.isHidden = false
        username.placeholder = "Username"
        username.textAlignment = .center
        view.addSubview(username)
        
        login.frame = CGRect(x: Double(screenSize.width/2-100), y: Double(screenSize.height/2)+150, width: 200, height: 30)
        login.layer.cornerRadius = 10
        login.layer.borderWidth = 1
        login.layer.borderColor = UIColor.white.cgColor
        login.layer.backgroundColor = UIColor.black.cgColor
        login.layer.isHidden = false
        login.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(login)
        
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
        
        UserDefaults.standard.set(true, forKey: "mute")
        UserDefaults.standard.set(false, forKey: "firsttime")
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true) // to dismiss the keyboard after writing on textfields
    }
    
    @IBAction func onlogin(_ sender: Any) {
        
        tapAudio.play()
        
        if(CheckInternet.Connection()) // Check internet connection
        {
            if(username.text != "")
            {
                // READ VALUES from Database
                ref.child("User/" + (username.text)! + "/id").observeSingleEvent(of: .value) { (snapshot) in
                    let dataname = snapshot.value as? String
                    if(dataname != nil && dataname == self.userPhoneID) //if the user exists and the passwort be the same as on the database
                    {
                        UserDefaults.standard.set(true, forKey: "firsttime")
                        UserDefaults.standard.set(self.username.text, forKey: "username") // to get the username for other views
                        
                        // READ VALUES from Database
                        self.ref.child("Records/" + (self.username.text)! + "/score").observeSingleEvent(of: .value) { (snapshot) in
                            let dataname = snapshot.value as? Int
                            UserDefaults.standard.set(String(dataname!), forKey: "key")
                        }
                        
                        //to open the menu
                        let menu = self.storyboard?.instantiateViewController(withIdentifier:  "menu") as! SWRevealViewController
                        
                        self.present(menu, animated: true, completion: nil)
                    }
                    else
                    {
                        if(dataname != self.userPhoneID && dataname != nil)
                        {
                            UserDefaults.standard.set(false, forKey: "firsttime")
                            
                            if(self.locale! == "de")
                            {
                                self.fourth = "\nNicht dein Benutzername!\n"
                            }
                            else if(self.locale! == "tr")
                            {
                                self.fourth = "\nKullanıcı adın degil!\n"
                            }else if(self.locale! == "en")
                            {
                                self.fourth = "\nNot your username!\n"
                            }
                            let alert = UIAlertController(title: "Error", message: "\n" + self.fourth + "\n", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { UIAlertAction in
                                switch (UIAlertAction.style){
                                case .default:
                                    print("default")
                                    
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if((self.username.text?.count)! < 3)
                        {
                            UserDefaults.standard.set(false, forKey: "firsttime")
                            
                            if(self.locale! == "de")
                            {
                                self.fourth = "\nDer Benutzername muss mindestens 3 Zeichen haben.\n"
                            }
                            else if(self.locale! == "tr")
                            {
                                self.fourth = "\nKullanıcı adı en az 3 sembol olmalı.\n"
                            }else if(self.locale! == "en")
                            {
                                self.fourth = "\nUsername must have at least 3 characters.\n"
                            }
                            let alert = UIAlertController(title: "Error", message: "\n" + self.fourth + "\n", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { UIAlertAction in
                                switch (UIAlertAction.style){
                                case .default:
                                    print("default")
                                    
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if(dataname == nil)
                        {
                            self.ref.child("User/" + (self.username.text)!).setValue((self.username.text)!)
                            self.ref.child("User/" + (self.username.text)! + "/id").setValue(self.userPhoneID)
                            
                            UserDefaults.standard.set(true, forKey: "firsttime")
                            UserDefaults.standard.set(self.username.text, forKey: "username") // to get the username for other views
                            
                            // READ VALUES from Database
                            self.ref.child("Records/" + (self.username.text)! + "/score").observeSingleEvent(of: .value) { (snapshot) in
                                let dataname = snapshot.value as? Int
                                UserDefaults.standard.set(String(dataname!), forKey: "key")
                            }
                            
                            //to open the menu
                            let menu = self.storyboard?.instantiateViewController(withIdentifier:  "menu") as! SWRevealViewController
                            
                            self.present(menu, animated: true, completion: nil)
                        }
                    }
                }
            }
            else
            {
                UserDefaults.standard.set(false, forKey: "firsttime")
                
                if(self.locale! == "de")
                {
                    self.fourth = "\nDer Benutzername darf nicht leer sein.\n"
                }
                else if(self.locale! == "tr")
                {
                    self.fourth = "\nKullanıcı adı bos kalamaz.\n"
                }else if(self.locale! == "en")
                {
                    self.fourth = "\nUsername can not be empty.\n"
                }
                let alert = UIAlertController(title: "Error", message: "\n" + self.fourth + "\n", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { UIAlertAction in
                    switch (UIAlertAction.style){
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            UserDefaults.standard.set(false, forKey: "firsttime")
            
            if(self.locale! == "de")
            {
                self.second = "Ist dein Gerät mit dem Internet verbunden?"
            }
            else if(self.locale! == "tr")
            {
                self.second = "Cihazınız internete bağlı mı?"
            }else if(self.locale! == "en")
            {
                self.second = "Do your device connect with the internet?"
            }
            let alert = UIAlertController(title: "Error", message: "\n" + self.second + "\n", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { UIAlertAction in
                switch (UIAlertAction.style){
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
