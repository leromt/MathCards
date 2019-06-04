//
//  ViewController.swift
//  MathCards
//
//  Created by Thomas Morel on 5/24/19.
//  Copyright © 2019 Thomas Morel. All rights reserved.
//

import UIKit

var playCount:Int = 0

class ViewController: UIViewController {

    @IBOutlet weak var answerStack: UIStackView!
    @IBOutlet weak var optionStack: UIStackView!
    @IBOutlet weak var finalMessage: UILabel!
    @IBOutlet weak var choiceLabel: UILabel!

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var answerLeft: UIButton!
    @IBOutlet weak var answerCenter: UIButton!
    @IBOutlet weak var answerRight: UIButton!
    @IBOutlet weak var changePreferences: UIButton!
    @IBOutlet weak var equationAnswerLabel: UILabel!
    @IBOutlet weak var equationLabel: UILabel!
    @IBOutlet weak var cardView: UIView!

    var cardFlipped:Bool = false;
    var total:Int = 0;
    var firstNumber = 0
    var secondNumber = 0
    var correctAnswer = 0
    var correctAnswer_string:String = ""
    var answeredCorrectly = 0
    var numberOfQuestions = 1
    var highestNumber = 2


    override func viewDidLoad() {
        super.viewDidLoad()

        print("view controller did load")

        optionStack.isHidden = true
        changePreferences.isHidden = true
        equationAnswerLabel.isHidden = true
        equationLabel.isHidden = false

        readPreferences()
        setEquation()
        setAnswerOptions()

    }

    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {

    }

    @IBAction func endGame(_ sender: UIButton) {
    }

    @IBAction func playAgainPressed(_ sender: Any) {
        readPreferences()
        playCount = 0
        answeredCorrectly = 0
        changePreferences.isHidden = true
        optionStack.isHidden = true
        finalMessage.isHidden = true
        flipCard(sender as! UIButton)

    }

    @IBAction func flipCard(_ sender: UIButton) {

        cardFlipped = !cardFlipped

        if(cardFlipped){

            playCount += 1
            choiceLabel.isHidden = true
            equationLabel.isHidden = true
            equationAnswerLabel.isHidden = false

            //answerStack.bringSubviewToFront(nextButton)
            let submittedAnswer = sender.title(for: .normal)
            if(submittedAnswer == correctAnswer_string){

                answeredCorrectly += 1
                cardView.backgroundColor = UIColor(red: 0, green: 143, blue: 0, alpha: 1)

            }
            else{
                cardView.backgroundColor = UIColor.red
                cardView.shake()
               // answerStack.isHidden = false
                //nextButton.isHidden = true
               // optionStack.isHidden = true
               // finalMessage.isHidden = true
                //equationLabel.isHidden = false
                //equationAnswerLabel.isHidden = true

            }
           // answerStack.isHidden = true
           // nextButton.isHidden = false

            if(playCount >= numberOfQuestions){
                answerStack.isHidden = true
                nextButton.isHidden = true
                finalMessage.text = "You got \(answeredCorrectly)\nout of \(numberOfQuestions) correct!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.optionStack.isHidden = false
                    self.finalMessage.isHidden = false;
                    self.changePreferences.isHidden = false
                }

            }
            else{
                nextButton.isHidden = false
                answerStack.isHidden = true
            }
            equationAnswerLabel.text = String(total)
            //equationLabel.font =  equationLabel.font.withSize(120.0)
            //equationLabel.sizeToFit()
        }
        else{
            setEquation()
            setAnswerOptions()
            answerStack.isHidden = false
            choiceLabel.isHidden = false
            nextButton.isHidden = true
            equationAnswerLabel.isHidden = true
            equationLabel.isHidden = false
            cardView.backgroundColor = UIColor.white
            //equationLabel.font =  equationLabel.font.withSize(64.0)
            //cardView.backgroundColor = UIColor.white
            equationLabel.sizeToFit()

        }

        UIView.transition(from: cardView, to: cardView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews])


    }
    private func setEquation(){
        firstNumber = Int.random(in: 0 ... highestNumber)
        secondNumber = Int.random(in: 0 ... highestNumber)

        total = firstNumber + secondNumber

        equationLabel.text = "\(firstNumber) + \(secondNumber) = ?"

    }

    private func setAnswerOptions(){

        var answerArray:[String] = [String]()

        correctAnswer_string = String(total)
        answerArray.append(correctAnswer_string)


        repeat{
            let nextNumber = Int.random(in: 0...(highestNumber*2))
            if !answerArray.contains(String(nextNumber)){
                answerArray.append(String(nextNumber))
            }

        }while answerArray.count < 3

        //answerArray.append(String(Int.random(in: 0...20)))
        //answerArray.append(String(Int.random(in: 0...20)))
        answerArray.shuffle()
        answerLeft.setTitle(answerArray[0], for: .normal)
        answerRight.setTitle(answerArray[1], for: .normal)
        answerCenter.setTitle(answerArray[2], for: .normal)

    }

    
    func getPlist(withName name: String) -> [String]?
    {
        if  let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path)
        {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
        }

        return nil
    }
    fileprivate func readPreferences() {
        let path        = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Preferences.plist")
        if  //let path        = Bundle.main.path(forResource: "Preferences", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path.path),
            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml){
            //print("after save, rereading preferences")
           // print(preferences)
            //print("rereading done")
            highestNumber = preferences.highestNumber
            numberOfQuestions = preferences.numberOfQuestions
        }
    }


}



extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 60, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

//put code here

//        let path        = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Preferences.plist")
//
//        if  //let path        = Bundle.main.path(forResource: "Preferences", ofType: "plist"),
//            let xml         = FileManager.default.contents(atPath: path.path),
//            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml)
//
//        {
//
//            highestNumber = preferences.highestNumber
//            numberOfQuestions = preferences.numberOfQuestions
//            print(preferences.highestNumber)
//        }
//        else{
//            print("There was a problem")
//        }
//        if  let path        = Bundle.main.path(forResource: "Preferences", ofType: "plist"),
//            let xml         = FileManager.default.contents(atPath: path),
//            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml)
//        {
//            highestNumber = preferences.highestNumber
//            numberOfQuestions = preferences.numberOfQuestions
//        }
//        else{
//            print("There was a problem in ViewDidLoad")
//        }

//        answerStack.addSubview(nextButton)


//
//            let encoder = PropertyListEncoder()
//            encoder.outputFormat = .xml
//
//            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Preferences.plist")
//
//            let preferences = Preferences(highestNumber: 6, numberOfQuestions: 3)
//
//            do {
//                let data = try encoder.encode(preferences)
//                try data.write(to: URL(fileURLWithPath: path.path))
//                print("Save pressed")
//                print(preferences)
//                print("data follows")
//                print(data)
//                print("data ended")
//                let path        = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Preferences.plist")
//                if  //let path        = Bundle.main.path(forResource: "Preferences", ofType: "plist"),
//                    let xml         = FileManager.default.contents(atPath: path.path),
//                    let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml){
//                    print("after save, rereading preferences")
//                    print(preferences)
//                    print("rereading done")
//                }
//            } catch {
//                print("error starts")
//
//                print(error)
//                print("error ends")
//            }
//
//            print(preferences)


