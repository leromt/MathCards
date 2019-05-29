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
    
    var cardFlipped:Bool = false;
    var total:Int = 0;
    var firstNumber = 0
    var secondNumber = 0
    var correctAnswer = 0
    var correctAnswer_string:String = ""
    var answeredCorrectly = 0
    var numberOfQuestions = 0
    var highestNumber = 0

    @IBOutlet weak var equationLabel: UILabel!
    @IBOutlet weak var cardView: UIView!



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        optionStack.isHidden = true;

                if  let path        = Bundle.main.path(forResource: "Preferences", ofType: "plist"),
                    let xml         = FileManager.default.contents(atPath: path),
                    let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml)
                {
                    highestNumber = preferences.highestNumber
                    numberOfQuestions = preferences.numberOfQuestions
                }
                else{
                    print("There was a problem in ViewDidLoad")
                }


        setEquation()
        setAnswerOptions()
        //equationLabel.shake()


        answerLeft.layer.cornerRadius = 4
    }

    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {}



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



//    func flipCardFunc() {
//
//
//
//        cardFlipped = !cardFlipped
//
//        if(cardFlipped){
//
//
//            cardView.backgroundColor = UIColor.green
//            equationLabel.text = String(total)
//            equationLabel.font =  equationLabel.font.withSize(120.0)
//            //equationLabel.sizeToFit()
//        }
//        else{
//            setEquation()
//            setAnswerOptions()
//            equationLabel.font =  equationLabel.font.withSize(64.0)
//            cardView.backgroundColor = UIColor.white
//            equationLabel.sizeToFit()
//
//        }
//
// UIView.transition(from: cardView, to: cardView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews])
//
//
////        if isCardFliped == false {
////            cardTextView.text = cards[counter].textOnBackSideCard
////            isCardFliped = true
////        } else {
////            cardTextView.text = cards[counter].textOnFrontSideCard
////            isCardFliped = false
////        }
//    }



//    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
//
//        //put code here
//        if  let path        = Bundle.main.path(forResource: "Preferences", ofType: "plist"),
//            let xml         = FileManager.default.contents(atPath: path),
//            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml)
//        {
//            highestNumber = preferences.highestNumber
//            numberOfQuestions = preferences.numberOfQuestions
//        }
//        else{
//            print("There was a problem")
//        }
//    }


    @IBAction func endGame(_ sender: UIButton) {

    }

    @IBAction func flipCard(_ sender: UIButton) {

        if(sender.title(for: .normal) == "Play Again"){
            optionStack.isHidden = true
            answerStack.isHidden = false
            finalMessage.isHidden = true
            playCount = 0
            answeredCorrectly = 0

        }

        cardFlipped = !cardFlipped

        if(cardFlipped){

            playCount += 1
            choiceLabel.isHidden = true
            
            //answerStack.bringSubviewToFront(nextButton)
            let submittedAnswer = sender.title(for: .normal)


            if(submittedAnswer == correctAnswer_string){

                answeredCorrectly += 1
                cardView.backgroundColor = UIColor.green

           }
            else{
                cardView.backgroundColor = UIColor.red
                cardView.shake()
                answerStack.isHidden = false
                nextButton.isHidden = true

            }
            answerStack.isHidden = true
            nextButton.isHidden = false

            if(playCount == numberOfQuestions){
                answerStack.isHidden = true
                nextButton.isHidden = true
                finalMessage.text = "You got \(answeredCorrectly) correct!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.optionStack.isHidden = false
                    self.finalMessage.isHidden = false;
                }

            }
            equationLabel.text = String(total)
            equationLabel.font =  equationLabel.font.withSize(120.0)
            //equationLabel.sizeToFit()
        }
        else{
            setEquation()
            setAnswerOptions()
            answerStack.isHidden = false
            choiceLabel.isHidden = false
            nextButton.isHidden = true
            equationLabel.font =  equationLabel.font.withSize(64.0)
            cardView.backgroundColor = UIColor.white
            equationLabel.sizeToFit()

        }

        UIView.transition(from: cardView, to: cardView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews])


        //        if isCardFliped == false {
        //            cardTextView.text = cards[counter].textOnBackSideCard
        //            isCardFliped = true
        //        } else {
        //            cardTextView.text = cards[counter].textOnFrontSideCard
        //            isCardFliped = false
        //        }   }
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

}

extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 60, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

