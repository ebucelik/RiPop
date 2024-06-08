//
//  GameViewController.swift
//  RiPop
//
//  Created by Ebu Bekir Celik on 20.12.18.
//  Copyright © 2018 KeepEasy. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet var myview: UIView!
    @IBOutlet var playagain: UIButton!
    @IBOutlet var back: UIButton!
    let points = UITextView()
    let levelText = UITextView()
    let levelTime = UITextView()
    let levelExtraTime = UITextView()
    let gameStartTimeText = UITextView()
    var gameView:SCNView!
    var gameScene:SCNScene!
    var cameraNode:SCNNode!
    let screenSize = UIScreen.main.bounds
    var time: Timer!
    var changeColorTime: Timer!
    var levelTimer: Timer!
    var levelGameTimer: Timer!
    var gameStartTimer: Timer!
    var ball: UIBezierPath!
    var lifeball1: UIBezierPath!
    var lifeball2: UIBezierPath!
    var lifeball3: UIBezierPath!
    let shapeLayer = CAShapeLayer()
    let shapeLayerLifeBall1 = CAShapeLayer()
    let shapeLayerLifeBall2 = CAShapeLayer()
    let shapeLayerLifeBall3 = CAShapeLayer()
    var okay: [Bool] = [false, false, false, false, false]
    var oneTime = true
    var oneTimeLevelTime = true
    var changeViewColor = true
    var enableGame = false
    var pointsRight = false //this variable I need to catch the error if the user throw the ball and the color be changed at the same time
    var touchDownY = 0.0
    var touchDownX = 0.0
    var width = 0.0
    var height = 0.0
    var rectangleRed = Draw()
    var rectanglePurple = Draw()
    var rectangleGreen = Draw()
    var rectangleOrange = Draw()
    var targetCreationTime:TimeInterval = 0
    var number = 0
    var numberBall = 0
    var point = 0
    var counter = 0
    var levelCounter = 0
    var levelCnt = 1
    var changeColorCnt = 5
    var animationCnt = 0
    var levelTimerCounterMilliSec = 9
    var levelTimerCounterSec = 30
    var gameStartTimerCnt = 4
    var numberBackground = 0
    var gameOverLang = String()
    var okayLang = String()
    var yourScoreLang = String()
    var audio = AVAudioPlayer() //for the sound effect
    var audioFalse = AVAudioPlayer() //for the sound effect if false
    var audioLevelUp = AVAudioPlayer()
    var tapAudio = AVAudioPlayer()
    var countdown = AVAudioPlayer()
    var startSound = AVAudioPlayer()
    let rec = UserDefaults.standard.object(forKey: "key") // to save the record local
    let recMute = UserDefaults.standard.bool(forKey: "mute") //for the mute
    var muteokay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locale = NSLocale.current.languageCode
        
        if(locale! == "de")
        {
            gameOverLang = "GameOver".localizabelString(loc: "de")
            yourScoreLang = "YourScore".localizabelString(loc: "de")
            okayLang = "OkayBtn".localizabelString(loc: "de")
        }
        else if(locale! == "en")
        {
            gameOverLang = "GameOver".localizabelString(loc: "en")
            yourScoreLang = "YourScore".localizabelString(loc: "en")
            okayLang = "OkayBtn".localizabelString(loc: "en")
        }
        else if(locale! == "tr")
        {
            gameOverLang = "GameOver".localizabelString(loc: "tr")
            yourScoreLang = "YourScore".localizabelString(loc: "tr")
            okayLang = "OkayBtn".localizabelString(loc: "tr")
        }
        
        if let okay = recMute as? Bool
        {
            if(okay)
            {
                muteokay = true //Gamemusic on
            }
            else
            {
                muteokay = false //Gamemusic off
            }
        }
        
        //swipe function initialization begin
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        //its default right
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        //swipe function initialization end
        
        //sound effect - begin
        let sound = Bundle.main.path(forResource: "ballsound", ofType: ".mp3")
        
        do
        {
            try audio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
        
        catch{
            print(error)
        }
        
        let soundFalse = Bundle.main.path(forResource: "falsesound", ofType: ".mp3")
        
        do
        {
            try audioFalse = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFalse!))
        }
            
        catch{
            print(error)
        }
        
        let soundLevelUp = Bundle.main.path(forResource: "levelup", ofType: ".mp3")
        
        do
        {
            try audioLevelUp = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundLevelUp!))
        }
            
        catch{
            print(error)
        }
        
        let soundTap = Bundle.main.path(forResource: "tap", ofType: ".mp3")
        
        do
        {
            try tapAudio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundTap!))
        }
            
        catch{
            print(error)
        }
        
        let soundCountdown = Bundle.main.path(forResource: "countdown", ofType: ".mp3")
        
        do
        {
            try countdown = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundCountdown!))
        }
            
        catch{
            print(error)
        }
        
        let soundStart = Bundle.main.path(forResource: "start", ofType: ".mp3")
        
        do
        {
            try startSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundStart!))
        }
            
        catch{
            print(error)
        }
        //sound effect - end
        
        width = Double(screenSize.width)
        height = Double(screenSize.height)
        
        numberBall = Int.random(in: 1 ... 4)
        createTarget()
        createBall()
        createLifeBalls()
        
        okay.insert(true, at: 4)
        
        levelTime.frame = CGRect(x: width/2-20, y: height-90, width: 50, height: 30)
        levelTime.backgroundColor = .black
        levelTime.textColor = .white
        levelTime.text = "30.0"
//        levelTime.font = UIFont(name: (levelTime.font?.fontName)!, size: 16)
        levelTime.isEditable = false
        levelTime.isSelectable = false
        view.addSubview(levelTime)
        
        levelExtraTime.frame = CGRect(x: width/2+20, y: height-90, width: 60, height: 30)
        levelExtraTime.backgroundColor = .clear
        levelExtraTime.textColor = .green
        levelExtraTime.text = "+30.0"
//        levelExtraTime.font = UIFont(name: (levelExtraTime.font?.fontName)!, size: 16)
        levelExtraTime.isEditable = false
        levelExtraTime.isSelectable = false
        levelExtraTime.isHidden = true
        view.addSubview(levelExtraTime)
        
        levelText.frame = CGRect(x: width/2-50, y: 130, width: 110, height: 60)
        levelText.backgroundColor = .black
        levelText.textColor = .white
        levelText.text = "Level " + String(levelCnt)
//        levelText.font = UIFont(name: (levelText.font?.fontName)!, size: 23)
        levelText.isEditable = false
        levelText.isSelectable = false
        view.addSubview(levelText)
        
        points.frame = CGRect(x: 15, y: 0, width: 60, height: 40)
        points.backgroundColor = .black
        points.textColor = .white
        points.text = String(point)
//        points.font = UIFont(name: (points.font?.fontName)!, size: 18)
        points.isEditable = false
        points.isSelectable = false
        view.addSubview(points)
        
        playagain.frame = CGRect(x: width/2-75, y: height/2-120, width: 150, height: 60)
        playagain.layer.cornerRadius = 10
        playagain.layer.borderWidth = 1
        playagain.layer.borderColor = UIColor.white.cgColor
        playagain.layer.backgroundColor = UIColor.black.cgColor
        playagain.layer.isHidden = true
        view.addSubview(playagain)
        
        back.frame = CGRect(x: width/2-75, y: height/2+30, width: 150, height: 60)
        back.layer.cornerRadius = 10
        back.layer.borderWidth = 1
        back.layer.borderColor = UIColor.white.cgColor
        back.layer.backgroundColor = UIColor.black.cgColor
        back.layer.isHidden = true
        view.addSubview(back)
        
        changeColorTime = Timer.scheduledTimer(timeInterval: Double(changeColorCnt), target: self, selector: #selector(changeColor), userInfo: nil, repeats: true)
        levelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(level), userInfo: nil, repeats: true)
        levelGameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(levelGameTime), userInfo: nil, repeats: true)
        gameStartTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameStart), userInfo: nil, repeats: true)
        
        //to stop the runnable timer until the 3,2,1 timer is finished
        changeColorTime.invalidate()
        levelTimer.invalidate()
        levelGameTimer.invalidate()
        
        if(muteokay)
        {
            audioLevelUp.play()
        }
    }
    
    //The swipe function left, up, down, right
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if(sender.state == .ended && enableGame)
        {
            switch (sender.direction)
            {
            case .right:
                if(okay[4])
                {
                    pointsRight = false
                    
                    if(muteokay)
                    {
                        audio.play() // sound effect
                    }
                    
                    okay.remove(at: 3)
                    okay.insert(true, at: 3)
                    
                    //to disable the double klick on the screen to make the ball faster
                    okay.remove(at: 4)
                    okay.insert(false, at: 4)
                    
                    time = Timer.scheduledTimer(timeInterval: 0.0003, target: self, selector: #selector(moveSymbol), userInfo: nil, repeats: true)
                }
            case .left:
                if(okay[4])
                {
                    pointsRight = false
                    
                    if(muteokay)
                    {
                        audio.play() // sound effect
                    }
                    
                    okay.remove(at: 1)
                    okay.insert(true, at: 1)
                    
                    //to disable the double klick on the screen to make the ball faster
                    okay.remove(at: 4)
                    okay.insert(false, at: 4)
                    
                    time = Timer.scheduledTimer(timeInterval: 0.0003, target: self, selector: #selector(moveSymbol), userInfo: nil, repeats: true)
                }
            case .up:
                if(okay[4])
                {
                    pointsRight = false
                    
                    if(muteokay)
                    {
                        audio.play() // sound effect
                    }
                    okay.remove(at: 2)
                    okay.insert(true, at: 2)
                    
                    //to disable the double klick on the screen to make the ball faster
                    okay.remove(at: 4)
                    okay.insert(false, at: 4)
                    
                    time = Timer.scheduledTimer(timeInterval: 0.0003, target: self, selector: #selector(moveSymbol), userInfo: nil, repeats: true)
                }
            case .down:
                if(okay[4])
                {
                    pointsRight = false
                    
                    if(muteokay)
                    {
                        audio.play() // sound effect
                    }
                    
                    //to set the okay at the first index to true to create the next ball on the screen
                    okay.remove(at: 0)
                    okay.insert(true, at: 0)
                    
                    //to disable the double klick on the screen to make the ball faster
                    okay.remove(at: 4)
                    okay.insert(false, at: 4)
                    
                    time = Timer.scheduledTimer(timeInterval: 0.0003, target: self, selector: #selector(moveSymbol), userInfo: nil, repeats: true)
                }
            default:
                break
            }
        }
    }
    
    @IBAction func onplayagain(_ sender: Any) {
        if(muteokay)
        {
            tapAudio.play()
        }
    }
    
    @IBAction func onbacktomenu(_ sender: Any) {
        if(muteokay)
        {
            tapAudio.play()
        }
    }
    
    @objc func gameStart()
    {
        gameStartTimerCnt -= 1
        
        if(gameStartTimerCnt == 0)
        {
            if(muteokay)
            {
                startSound.play()
            }
            gameStartTimer.invalidate()
            enableGame = true
            changeColorTime = Timer.scheduledTimer(timeInterval: Double(changeColorCnt), target: self, selector: #selector(changeColor), userInfo: nil, repeats: true)
            levelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(level), userInfo: nil, repeats: true)
            levelGameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(levelGameTime), userInfo: nil, repeats: true)
            gameStartTimeText.isHidden = true
        }
        else
        {
            if(muteokay)
            {
                countdown.play()
            }
        }
        
        //the text have stroke with them
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.white,
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.strokeWidth : -2.0]
            as [NSAttributedString.Key : Any]
        
        //the timer text 3,2,1...
        gameStartTimeText.frame = CGRect(x: width/2-200, y: height/2-100, width: 400, height: 400)
        gameStartTimeText.backgroundColor = .clear
        gameStartTimeText.attributedText = NSMutableAttributedString(string: String(gameStartTimerCnt), attributes: strokeTextAttributes)
        gameStartTimeText.textAlignment = .center
//        gameStartTimeText.font = UIFont(name: (gameStartTimeText.font?.fontName)!, size: 150)
        gameStartTimeText.isEditable = false
        gameStartTimeText.isSelectable = false
        view.addSubview(gameStartTimeText)
    }
    
    func addPoints()
    {
        point += 1
        points.text = String(point)
        
        if(point != 0 && point%4 == 0 && point%10 == 0)
        {
            levelCounter = 0
            levelCnt += 1
            levelText.isHidden = false
            levelText.text = "Level " + String(levelCnt)
            levelExtraTime.isHidden = false
            changeColorTime.invalidate()
            if(changeColorCnt != 2) // the speed for the random change color of the rectangles
            {
                changeColorCnt -= 1
            }
            changeColorTime = Timer.scheduledTimer(timeInterval: Double(changeColorCnt), target: self, selector: #selector(changeColor), userInfo: nil, repeats: true)
            if(muteokay)
            {
                audioLevelUp.play()
            }
            levelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(level), userInfo: nil, repeats: true)
            
            if(counter == 1)
            {
                counter -= 1
                shapeLayerLifeBall3.fillColor = UIColor.red.cgColor
            }
            else if(counter == 2)
            {
                counter -= 1
                shapeLayerLifeBall2.fillColor = UIColor.red.cgColor
            }
            else if(counter == 3)
            {
                counter -= 1
                shapeLayerLifeBall1.fillColor = UIColor.red.cgColor
            }
        }
        oneTimeLevelTime = true
    }
    
    @objc func levelGameTime()
    {
        levelTimerCounterMilliSec -= 1
        
        if(levelTimerCounterMilliSec == 0)
        {
            //Ball animation begin
            UIView.animate(withDuration: 1, animations: {
                
            }){
                _ in
                UIView.animate(withDuration: 1, delay: 0.25, options: [.autoreverse], animations: {
                    if(self.animationCnt == 1)
                    {
                        self.shapeLayer.frame.origin.y += 10
                        if(Double(self.shapeLayer.frame.origin.y) == 0)
                        {
                            self.animationCnt = 0
                        }
                    }
                    else {
                        self.shapeLayer.frame.origin.y -= 10
                        self.animationCnt += 1
                    }
                })
            }
            //Ball animation end
            
            if(levelTimerCounterSec == 0 && levelTimerCounterMilliSec == 0)
            {
                let alert = UIAlertController(title: gameOverLang, message: "\n" + yourScoreLang + String(point) + "\n", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: okayLang, style: .cancel, handler: { UIAlertAction in
                    switch (UIAlertAction.style){
                    case .default:
                        print("default")
                        
                    case .cancel:
                        self.playagain.layer.isHidden = false
                        self.view.addSubview(self.playagain)
                        self.back.layer.isHidden = false
                        self.view.addSubview(self.back)
                        
                    case .destructive:
                        print("destructive")
                    }
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                if let recordName = rec as? String
                {
                    if(Int(recordName)! < point)
                    {
                        UserDefaults.standard.set(String(point), forKey: "key")
                    }
                }
                else if(rec == nil)
                {
                    UserDefaults.standard.set(String(point), forKey: "key")
                }
                enableGame = false
                levelGameTimer.invalidate()
            }
            else{
                levelTimerCounterSec -= 1
                levelTimerCounterMilliSec = 9
            }
        }
        
        levelTime.text = String(levelTimerCounterSec) + "." + String(levelTimerCounterMilliSec)
        
        if(point != 0 && point%4 == 0 && point%10 == 0 && levelTimerCounterSec > 0 && levelTimerCounterMilliSec > 0 && oneTimeLevelTime)
        {
            levelTimerCounterSec += 30
            oneTimeLevelTime = false
        }
    }
    
    @objc func level()
    {
        levelCounter += 1
        
        if(levelCounter == 3)
        {
            levelText.isHidden = true
            levelExtraTime.isHidden = true
            levelTimer.invalidate()
        }
    }
    
    @objc func moveSymbol()
    {
        if(okay[0])
        {
            if(ball.currentPoint.y > screenSize.height)
            {
                width = Double(screenSize.width)
                height = Double(screenSize.height)
                
                //to determinate the time interval
                time.invalidate()
                //time = nil
                
                okay.remove(at: 4)
                okay.insert(true, at: 4)
                okay.remove(at: 0)
                okay.insert(false, at: 0)
                
                numberBall = Int.random(in: 1 ... 4)
                createBall()
            }
            else
            {
                //clear means a transparent background
                shapeLayer.fillColor = UIColor.clear.cgColor
                height += 1 // to move the ball
                createBall()
            }
            
            if(!pointsRight)
            {
                if(numberBall == 1 && rectangleGreen.backgroundColor == UIColor.orange)
                {
                    addPoints()
                }
                else if(numberBall == 2 && rectangleGreen.backgroundColor == UIColor.red)
                {
                    addPoints()
                }
                else if(numberBall == 3 && rectangleGreen.backgroundColor == UIColor.purple)
                {
                    addPoints()
                }
                else if(numberBall == 4 && rectangleGreen.backgroundColor == UIColor.green)
                {
                    addPoints()
                }
                else
                {
                    if(muteokay)
                    {
                        audioFalse.play()
                    }
                    
                    counter += 1
                    
                    if(counter == 1)
                    {
                        shapeLayerLifeBall3.fillColor = UIColor.clear.cgColor
                    }
                    else if(counter == 2)
                    {
                        shapeLayerLifeBall2.fillColor = UIColor.clear.cgColor
                    }
                    else if(counter == 3)
                    {
                        shapeLayerLifeBall1.fillColor = UIColor.clear.cgColor
                        
                        let alert = UIAlertController(title: gameOverLang, message: "\n" + yourScoreLang + String(point) + "\n", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: okayLang, style: .cancel, handler: { UIAlertAction in
                            switch (UIAlertAction.style){
                            case .default:
                                print("default")
                                
                            case .cancel:
                                self.playagain.layer.isHidden = false
                                self.view.addSubview(self.playagain)
                                self.back.layer.isHidden = false
                                self.view.addSubview(self.back)
                                
                            case .destructive:
                                print("destructive")
                            }
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        if let recordName = rec as? String
                        {
                            if(Int(recordName)! < point)
                            {
                                UserDefaults.standard.set(String(point), forKey: "key")
                            }
                        }
                        else if(rec == nil)
                        {
                            UserDefaults.standard.set(String(point), forKey: "key")
                        }
                        
                        enableGame = false
                        levelGameTimer.invalidate()
                    }
                }
                pointsRight = true
            }
        }
        else if(okay[1])
        {
            if(ball.currentPoint.x < -40)
            {
                width = Double(screenSize.width)
                height = Double(screenSize.height)
                
                //to determinate the time interval
                time.invalidate()
                //time = nil
                
                okay.remove(at: 4)
                okay.insert(true, at: 4)
                okay.remove(at: 1)
                okay.insert(false, at: 1)
                
                numberBall = Int.random(in: 1 ... 4)
                createBall()
            }
            else
            {
                //clear means a transparent background
                shapeLayer.fillColor = UIColor.clear.cgColor
                width -= 1 // to move the ball
                createBall()
            }
            
            if(!pointsRight)
            {
                if(numberBall == 1 && rectangleRed.backgroundColor == UIColor.orange)
                {
                    addPoints()
                }
                else if(numberBall == 2 && rectangleRed.backgroundColor == UIColor.red)
                {
                    addPoints()
                }
                else if(numberBall == 3 && rectangleRed.backgroundColor == UIColor.purple)
                {
                    addPoints()
                }
                else if(numberBall == 4 && rectangleRed.backgroundColor == UIColor.green)
                {
                    addPoints()
                }
                else
                {
                    if(muteokay)
                    {
                        audioFalse.play()
                    }
                        
                    counter += 1
                    
                    if(counter == 1)
                    {
                        shapeLayerLifeBall3.fillColor = UIColor.clear.cgColor
                    }
                    else if(counter == 2)
                    {
                        shapeLayerLifeBall2.fillColor = UIColor.clear.cgColor
                    }
                    else if(counter == 3)
                    {
                        shapeLayerLifeBall1.fillColor = UIColor.clear.cgColor
                        
                        let alert = UIAlertController(title: gameOverLang, message: "\n" + yourScoreLang + String(point) + "\n", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: okayLang, style: .cancel, handler: { UIAlertAction in
                            switch (UIAlertAction.style){
                            case .default:
                                print("default")
                                
                            case .cancel:
                                self.playagain.layer.isHidden = false
                                self.view.addSubview(self.playagain)
                                self.back.layer.isHidden = false
                                self.view.addSubview(self.back)
                                
                            case .destructive:
                                print("destructive")
                            }
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        if let recordName = rec as? String
                        {
                            if(Int(recordName)! < point)
                            {
                                UserDefaults.standard.set(String(point), forKey: "key")
                            }
                        }
                        else if(rec == nil)
                        {
                            UserDefaults.standard.set(String(point), forKey: "key")
                        }
                        
                        enableGame = false
                        levelGameTimer.invalidate()
                    }
                }
                pointsRight = true
            }
        }
        else if(okay[2])
        {
            if(ball.currentPoint.y < -40)
            {
                width = Double(screenSize.width)
                height = Double(screenSize.height)
                
                //to determinate the time interval
                time.invalidate()
                //time = nil
                
                okay.remove(at: 4)
                okay.insert(true, at: 4)
                okay.remove(at: 2)
                okay.insert(false, at: 2)
                
                numberBall = Int.random(in: 1 ... 4)
                createBall()
            }
            else
            {
                //clear means a transparent background
                shapeLayer.fillColor = UIColor.clear.cgColor
                height -= 1 // to move the ball
                createBall()
            }
            
            if(!pointsRight)
            {
                if(numberBall == 1 && rectangleOrange.backgroundColor == UIColor.orange)
                {
                    addPoints()
                }
                else if(numberBall == 2 && rectangleOrange.backgroundColor == UIColor.red)
                {
                    addPoints()
                }
                else if(numberBall == 3 && rectangleOrange.backgroundColor == UIColor.purple)
                {
                    addPoints()
                }
                else if(numberBall == 4 && rectangleOrange.backgroundColor == UIColor.green)
                {
                    addPoints()
                }
                else
                {
                    if(muteokay)
                    {
                        audioFalse.play()
                    }
                    
                    counter += 1
                    
                    if(counter == 1)
                    {
                        shapeLayerLifeBall3.fillColor = UIColor.clear.cgColor
                    }
                    else if(counter == 2)
                    {
                        shapeLayerLifeBall2.fillColor = UIColor.clear.cgColor
                    }
                    else if(counter == 3)
                    {
                        shapeLayerLifeBall1.fillColor = UIColor.clear.cgColor
                        
                        let alert = UIAlertController(title: gameOverLang, message: "\n" + yourScoreLang + String(point) + "\n", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: okayLang, style: .cancel, handler: { UIAlertAction in
                            switch (UIAlertAction.style){
                            case .default:
                                print("default")
                                
                            case .cancel:
                                self.playagain.layer.isHidden = false
                                self.view.addSubview(self.playagain)
                                self.back.layer.isHidden = false
                                self.view.addSubview(self.back)
                                
                            case .destructive:
                                print("destructive")
                            }
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        if let recordName = rec as? String
                        {
                            if(Int(recordName)! < point)
                            {
                                UserDefaults.standard.set(String(point), forKey: "key")
                            }
                        }
                        else if(rec == nil)
                        {
                            UserDefaults.standard.set(String(point), forKey: "key")
                        }
                        
                        enableGame = false
                        levelGameTimer.invalidate()
                    }
                }
                pointsRight = true
            }
        }
        else if(okay[3])
        {
            if(ball.currentPoint.x > screenSize.width + 40)
            {
                width = Double(screenSize.width)
                height = Double(screenSize.height)
                
                //to determinate the time interval
                time.invalidate()
                //time = nil
                
                okay.remove(at: 4)
                okay.insert(true, at: 4)
                okay.remove(at: 3)
                okay.insert(false, at: 3)
                
                numberBall = Int.random(in: 1 ... 4)
                createBall()
            }
            else
            {
                //clear means a transparent background
                shapeLayer.fillColor = UIColor.clear.cgColor
                width += 1 // to move the ball
                createBall()
            }
            
            if(!pointsRight)
            {
                if(numberBall == 1 && rectanglePurple.backgroundColor == UIColor.orange)
                {
                    addPoints()
                }
                else if(numberBall == 2 && rectanglePurple.backgroundColor == UIColor.red)
                {
                    addPoints()
                }
                else if(numberBall == 3 && rectanglePurple.backgroundColor == UIColor.purple)
                {
                    addPoints()
                }
                else if(numberBall == 4 && rectanglePurple.backgroundColor == UIColor.green)
                {
                    addPoints()
                }
                else
                {
                    if(muteokay)
                    {
                        audioFalse.play()
                    }
                    
                    counter += 1
                    
                    if(counter == 1)
                    {
                        shapeLayerLifeBall3.fillColor = UIColor.clear.cgColor
                    }
                    else if(counter == 2)
                    {
                        shapeLayerLifeBall2.fillColor = UIColor.clear.cgColor
                    }
                    else if(counter == 3)
                    {
                        shapeLayerLifeBall1.fillColor = UIColor.clear.cgColor
                        
                        let alert = UIAlertController(title: gameOverLang, message: "\n" + yourScoreLang + String(point) + "\n", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: okayLang, style: .cancel, handler: { UIAlertAction in
                            switch (UIAlertAction.style){
                            case .default:
                                print("default")
                                
                            case .cancel:
                                self.playagain.layer.isHidden = false
                                self.view.addSubview(self.playagain)
                                self.back.layer.isHidden = false
                                self.view.addSubview(self.back)
                                
                            case .destructive:
                                print("destructive")
                            }
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        if let recordName = rec as? String
                        {
                            if(Int(recordName)! < point)
                            {
                                UserDefaults.standard.set(String(point), forKey: "key")
                            }
                        }
                        else if(rec == nil)
                        {
                            UserDefaults.standard.set(String(point), forKey: "key")
                        }
                        
                        enableGame = false
                        levelGameTimer.invalidate()
                    }
                }
                pointsRight = true
            }
        }
    }
    
    @objc func changeColor()
    {
        number = Int.random(in: 1 ... 4)
        
        switch number {
        case 1:
            rectangleRed.backgroundColor = UIColor.purple
            rectangleOrange.backgroundColor = UIColor.red
            rectangleGreen.backgroundColor = UIColor.orange
            rectanglePurple.backgroundColor = UIColor.green
            self.view.addSubview(rectangleRed)
            self.view.addSubview(rectanglePurple)
            self.view.addSubview(rectangleOrange)
            self.view.addSubview(rectangleGreen)
        case 2:
            rectangleRed.backgroundColor = UIColor.green
            rectangleOrange.backgroundColor = UIColor.purple
            rectangleGreen.backgroundColor = UIColor.red
            rectanglePurple.backgroundColor = UIColor.orange
            self.view.addSubview(rectangleRed)
            self.view.addSubview(rectanglePurple)
            self.view.addSubview(rectangleOrange)
            self.view.addSubview(rectangleGreen)
        case 3:
            rectangleRed.backgroundColor = UIColor.orange
            rectangleOrange.backgroundColor = UIColor.green
            rectangleGreen.backgroundColor = UIColor.purple
            rectanglePurple.backgroundColor = UIColor.red
            self.view.addSubview(rectangleRed)
            self.view.addSubview(rectanglePurple)
            self.view.addSubview(rectangleOrange)
            self.view.addSubview(rectangleGreen)
        case 4:
            rectangleRed.backgroundColor = UIColor.red
            rectangleOrange.backgroundColor = UIColor.orange
            rectangleGreen.backgroundColor = UIColor.green
            rectanglePurple.backgroundColor = UIColor.purple
            self.view.addSubview(rectangleRed)
            self.view.addSubview(rectanglePurple)
            self.view.addSubview(rectangleOrange)
            self.view.addSubview(rectangleGreen)
        default:
            rectangleRed.backgroundColor = UIColor.red
            rectangleOrange.backgroundColor = UIColor.orange
            rectangleGreen.backgroundColor = UIColor.green
            rectanglePurple.backgroundColor = UIColor.purple
            self.view.addSubview(rectangleRed)
            self.view.addSubview(rectanglePurple)
            self.view.addSubview(rectangleOrange)
            self.view.addSubview(rectangleGreen)
        }
    }
    
    func createTarget(){

        rectangleRed = Draw(frame: CGRect(x: 0, y: 40, width: 20, height: height-80))
        rectangleRed.layer.cornerRadius = CGFloat(30)
        rectangleRed.backgroundColor = UIColor.red
        self.view.addSubview(rectangleRed)
        
        rectanglePurple = Draw(frame: CGRect(x: width-20, y: 40, width: 20, height: height-80))
        rectanglePurple.layer.cornerRadius = CGFloat(30)
        rectanglePurple.backgroundColor = UIColor.purple
        self.view.addSubview(rectanglePurple)
        
        rectangleGreen = Draw(frame: CGRect(x: 0, y: height-60, width: width, height: 20))
        rectangleGreen.layer.cornerRadius = CGFloat(30)
        rectangleGreen.backgroundColor = UIColor.green
        self.view.addSubview(rectangleGreen)
        
        rectangleOrange = Draw(frame: CGRect(x: 0, y: 40, width: width, height: 20))
        rectangleOrange.layer.cornerRadius = CGFloat(30)
        rectangleOrange.backgroundColor = UIColor.orange
        self.view.addSubview(rectangleOrange)
    }

    func createBall()
    {
        ball = UIBezierPath(arcCenter: CGPoint(x: width/2, y: height/2), radius: CGFloat(20), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        shapeLayer.path = ball.cgPath
        
        switch numberBall {
        case 1:
            shapeLayer.fillColor = UIColor.orange.cgColor
        case 2:
            shapeLayer.fillColor = UIColor.red.cgColor
        case 3:
            shapeLayer.fillColor = UIColor.purple.cgColor
        case 4:
            shapeLayer.fillColor = UIColor.green.cgColor
        default:
            shapeLayer.fillColor = UIColor.purple.cgColor
        }
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func createLifeBalls()
    {
        lifeball1 = UIBezierPath(arcCenter: CGPoint(x: width-70, y: 20), radius: CGFloat(5), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        shapeLayerLifeBall1.path = lifeball1.cgPath
        
        shapeLayerLifeBall1.fillColor = UIColor.red.cgColor
        
        view.layer.addSublayer(shapeLayerLifeBall1)
        
        lifeball2 = UIBezierPath(arcCenter: CGPoint(x: width-50, y: 20), radius: CGFloat(5), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        shapeLayerLifeBall2.path = lifeball2.cgPath
        
        shapeLayerLifeBall2.fillColor = UIColor.red.cgColor
        
        view.layer.addSublayer(shapeLayerLifeBall2)
        
        lifeball3 = UIBezierPath(arcCenter: CGPoint(x: width-30, y: 20), radius: CGFloat(5), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        shapeLayerLifeBall3.path = lifeball3.cgPath
        
        shapeLayerLifeBall3.fillColor = UIColor.red.cgColor
        
        view.layer.addSublayer(shapeLayerLifeBall3)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    class Draw: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
