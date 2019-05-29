//
//  PreferencesController.swift
//  MathCards
//
//  Created by Thomas Morel on 5/25/19.
//  Copyright © 2019 Thomas Morel. All rights reserved.
//

import Foundation
import UIKit

class PreferencesController: UIViewController
{

    var lowestNumber:Int = 0
    var highestNumber:Int = 0
    var numberOfQuestions = 0

    @IBOutlet weak var highestNumberLabel: UILabel!
    @IBOutlet weak var highestNumberSlider: UISlider!

    @IBOutlet weak var numberOfQuestionsSlider: UISlider!

    @IBOutlet weak var numberOfQuestionsLabel: UILabel!
    
    @IBAction func saveTapped(_ sender: Any) {

       saveToPreferences()
        print("Saved")
    }
    @IBAction func cancelPressed(_ sender: Any) {
    }
    
    @IBAction func lowestNumberSliderChanged(_ sender: Any) {
        let currentValue = Int((sender as! UISlider).value)

        highestNumberLabel.text = String(currentValue)
        highestNumber = currentValue
        print("\(currentValue)")
    }

    @IBAction func numberOfQuestionsChanged(_ sender: Any) {
        let currentValue = Int((sender as! UISlider).value)

        numberOfQuestions = currentValue

        numberOfQuestionsLabel.text = String(currentValue)
        print("\(currentValue)")
    }
    

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    override func viewDidLoad() {
        //put code here
        print("viewdidload")
        let path        = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Preferences.plist")

        if  //let path        = Bundle.main.path(forResource: "Preferences", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path.path),
            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml)

        {

            highestNumberLabel.text = String(preferences.highestNumber)
            numberOfQuestionsLabel.text = String(preferences.numberOfQuestions)
            numberOfQuestionsSlider.value = Float(preferences.highestNumber)
            highestNumberSlider.value = Float(preferences.highestNumber)
            print(preferences.highestNumber)
        }
        else{
            print("There was a problem")
        }
       // highestNumberLabel.text = String(highestNumberSlider.value)
       // numberOfQuestionsLabel.text = String(numberOfQuestionsSlider.value)
        print("got here")
    }

    private func saveToPreferences(){

        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Preferences.plist")

        let preferences = Preferences(highestNumber: highestNumber, numberOfQuestions: numberOfQuestions)

        do {
            let data = try encoder.encode(preferences)
            try data.write(to: path)
            print("Save pressed")
            print(preferences)
            print("data follows")
            print(data)
            print("data ended")
            if  let path        = Bundle.main.path(forResource: "Preferences", ofType: "plist"),
                let xml         = FileManager.default.contents(atPath: path),
                let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml){
                print("after save, rereading preferences")
                print(preferences)
                print("rereading done")
            }
        } catch {
            print(error)
        }

        print(preferences)


    }
}
