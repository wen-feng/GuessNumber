//
//  ViewController.swift
//  GuessNumber
//
//  Created by Wu, Weng-Feng on 2016/7/13.
//  Copyright © 2016年 Wu, Weng-Feng. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var warningMessage: UILabel!
    @IBOutlet weak var gameOverMessage: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    
    
    var counter:Int = 0
    var randomAnserArray:Array<Int> = [0,0,0,0]
    var resultArray:Array<String> = []
    var enterNumArray:Array<Int> = []
    var guessingTimes = 0
    var bestScore:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        numberTextField.delegate = self
        warningMessage.isHidden = true
        gameOverMessage.isHidden = true
        tableView.layer.borderColor = UIColor(red: 0/255, green: 128/255, blue:128/255, alpha: 1.0 ).cgColor
        tableView.layer.borderWidth = 2.0
        
//        let defaults = UserDefaults.standard()
//        if defaults.integer(forKey: "winTime") != nil {
//            bestScore = defaults.integer(forKey: "winTime")
//        }
//        noteTheBestScore()
        randomAnserArray = generateAnser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func goGuess(_ sender: UIButton) {
        
        if actionBtn.titleLabel?.text == "Go" {
            if numberTextField.text?.characters.count != 4 {
                warningMessage.isHidden = false
            } else {
                guessingTimes += 1
                warningMessage.isHidden = true
                compareNumber()
                if guessingTimes >= 6 {
                    gameOverMessage.isHidden = false
                    actionBtn.setTitle("Retry", for: [])
                }
            }
        }else {
            actionBtn.setTitle("Go", for: [])
            gameOverMessage.isHidden = true
            numberTextField.text = ""
            enterNumArray.removeAll()
            randomAnserArray.removeAll()
            randomAnserArray = generateAnser()
            resultArray.removeAll()
            guessingTimes = 0
            tableView.reloadData()
        }
    
    }
    
    func compareNumber(){
        var ACount = 0
        var BCount = 0
        if let str = numberTextField.text {
            enterNumArray = Array(str.characters.flatMap{Int(String($0))})
            for i in 0...enterNumArray.count - 1 {
                for j in 0...randomAnserArray.count - 1 {
                    if enterNumArray[i] == randomAnserArray[j] {
                        if i == j {
                            ACount += 1
                        } else {
                            BCount += 1
                        }
                    }
                }
            }
        }
        let result = "\(ACount)A\(BCount)B"
        if result == "4A0B" {
//            noteTheBestScore()
            actionBtn.setTitle("Retry", for: [])
            gameOverMessage.isHidden = false
        }
        resultArray += ["Result = \(ACount)A\(BCount)B"]
        tableView.reloadData()
    }
    
    func generateAnser() -> Array<Int> {
        var anserArray:Array<Int> = [0,0,0,0]
        var index = 0

        while index < anserArray.count {
            let randomNum = Int(arc4random_uniform(9) + 1);
            if !anserArray.contains(randomNum) {
                anserArray[index] = randomNum
                index += 1
            }

        }
        return anserArray
    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = resultArray[indexPath.row] + " Guess \(indexPath.row+1) time(s)"
        
        
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        
        return cell
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        if string == "0" {
            return false
        }

        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 4 // Bool
    }
    
    func noteTheBestScore() {
        let defaults = UserDefaults.standard()
        if bestScore > 0 {
            if bestScore > guessingTimes {
                bestScore = guessingTimes
                defaults.set(bestScore, forKey: "winTime")
            }
        } else {
            if guessingTimes > 0 {
                bestScore = guessingTimes
                defaults.set(bestScore, forKey: "winTime")
            }
        }
        
        bestScoreLabel.text = "\(bestScore) time(s)"
    }
    
    @IBAction func backgroundTap(_ sender: UIControl) {
        numberTextField.resignFirstResponder()
    }

}

