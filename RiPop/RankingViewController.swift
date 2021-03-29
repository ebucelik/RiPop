//
//  RankingViewController.swift
//  RiPop
//
//  Created by Ebu Bekir Celik on 04.01.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var highscoreView: UITableView!
    @IBOutlet var back: UIButton!
    @IBOutlet var ranking: UIButton!
    var tapAudio = AVAudioPlayer()
    let screenSize = UIScreen.main.bounds
    @IBOutlet var tableRecords: UITableView!
    var recordCount = 0
    var count = 0
    var countEnd = 0
    let recMute = UserDefaults.standard.bool(forKey: "mute")
    let ref = Database.database().reference().child("Records") //Database reference
    
    var records = [Records]() //ClassArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        highscoreView.frame = CGRect(x: Double(0), y: Double(100), width: Double(screenSize.width), height: Double(screenSize.height-200))
        highscoreView.layer.cornerRadius = 10
        highscoreView.layer.borderWidth = 1
        highscoreView.layer.borderColor = UIColor.white.cgColor
        highscoreView.layer.backgroundColor = UIColor.black.cgColor
        highscoreView.layer.isHidden = false
        view.addSubview(highscoreView)
        
        ranking.frame = CGRect(x: Double(screenSize.width/2-100), y: Double(50), width: 200, height: 30)
        ranking.layer.cornerRadius = 10
        ranking.layer.borderWidth = 1
        ranking.layer.borderColor = UIColor.white.cgColor
        ranking.layer.backgroundColor = UIColor.black.cgColor
        ranking.layer.isHidden = false
        ranking.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(ranking)
        
        back.frame = CGRect(x: Double(15), y: Double(screenSize.height)-50, width: 70, height: 30)
        back.layer.cornerRadius = 10
        back.layer.borderWidth = 1
        back.layer.borderColor = UIColor.white.cgColor
        back.layer.backgroundColor = UIColor.black.cgColor
        back.layer.isHidden = false
        back.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(back)
        
        //Read Data from Database and put it on the table view
        ref.observe(.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.records.removeAll()
                
                for allrecords in snapshot.children.allObjects as! [DataSnapshot]{
                    let recordObject = allrecords.value as? [String: AnyObject]
                    let score = recordObject?["score"]
                    let scorerName = recordObject?["name"]
                    
                    let rec = Records(score: score as? Int, scorerName: scorerName as? String)
                    
                    self.records.append(rec)
                }
                self.tableRecords.reloadData()
            }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recordCount = records.count
        
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankingTableViewCell
        
        let tabRecords: Records
        
        let scoreSorted = records.sorted(by: {$0.score! > $1.score!}) //Sort classarray from highest to lowest
        
        tabRecords = scoreSorted[indexPath.row]
        
        cell.userNumber.text = String(indexPath.row + 1) + "." //rankingnumber
        cell.usernameLabel.text = tabRecords.scorerName //ranking scorer
        cell.userrecordLabel.text = String(tabRecords.score!) //ranking score
        if(tabRecords.score == nil)
        {
            cell.userrecordLabel.text = "0"
        }
        
        return cell
    }
}
